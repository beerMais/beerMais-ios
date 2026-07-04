//
//  BeerWorker.swift
//  BeerMais
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import WidgetKit

import AmplitudeSwift

protocol BeerWorkerProtocol {
    @discardableResult func createBeer(data: BeerData) -> Beer?
    func getBeers() -> [Beer]
    func edit(beer: Beer, data: BeerData)
    func deleteAllBeers()
    func delete(beer: Beer)
    
    func orderBeers(_ beers: [Beer]) -> [Beer]
    func getValuePerML(beer: Beer) -> Float
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float
    func formatBeerValueToShow(value: Float) -> String
    func calculateMostValuableBeer(beers: [Beer]) -> (Beer, Float?)?
}

final class BeerWorker: BeerWorkerProtocol {
    
    // MARK: - Private properties
    
    private let entityName = "Beer"
    private let coreDataWorker: CoreDataWorkerProtocol
    
    // MARK: - Initialization
    
    init(coreDataWorker: CoreDataWorkerProtocol = CoreDataWorker.shared) {
        self.coreDataWorker = coreDataWorker
    }
    
    // MARK: - BeerWorkerProtocol
    
    @discardableResult func createBeer(data: BeerData) -> Beer? {
        guard let context = coreDataWorker.context else { return nil }
        
        var beer = Beer(context: context)
        setDataToBeer(beer: &beer, data: data)
        
        saveContext()
        updateWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_created",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
        
        return beer
    }
    
    func getBeers() -> [Beer] {
        guard let beers = coreDataWorker.getData(entityName: Beer.entityName) as? [Beer] else {
            return []
        }
        
        return orderBeers(beers)
    }
    
    func edit(beer: Beer, data: BeerData) {
        var beer = beer
        setDataToBeer(beer: &beer, data: data)
        saveContext()
        updateWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_updated",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
    }
    
    func deleteAllBeers() {
        coreDataWorker.deleteData(entityName: entityName)
        
        cleandWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "all_beers_deleted",
            eventProperties: nil
        ))
    }
    
    func delete(beer: Beer) {
        coreDataWorker.context?.delete(beer)
        saveContext()
        updateWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_deleted",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
    }
    
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        beers
            .map { beer in
                (beer: beer, valuePerML: getValuePerML(beer: beer))
            }
            .sorted { $0.valuePerML < $1.valuePerML }
            .map(\.beer)
    }
    
    func getValuePerML(beer: Beer) -> Float {
        beer.value / Float(beer.amount)
    }
    
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float {
        (getValuePerML(beer: beer2) - getValuePerML(beer: beer1)) * 1000
    }
    
    func formatBeerValueToShow(value: Float) -> String {
        String(format: "%.2f", value).replacingOccurrences(of: ".", with: ",")
    }
    
    func calculateMostValuableBeer(beers: [Beer]) -> (Beer, Float?)? {
        guard beers.count >= 2, let mostValuableBeer = beers.first else {
            return nil
        }
        
        let economy = calcEconomyBetweenBeers(beer1: mostValuableBeer, beer2: beers[1])
        return (mostValuableBeer, economy)
    }
    
    // MARK: - Private methods
    
    private func setDataToBeer(beer: inout Beer, data: BeerData) {
        beer.brand = data.brand
        beer.value = data.value
        beer.amount = data.amount
        beer.type = data.type
    }

    private func saveContext() {
        guard let context = coreDataWorker.context, context.hasChanges else { return }

        do {
            try context.save()
        } catch let error {
            print("Could not save. \(error), \(String(describing: error._userInfo))")
        }
    }
    
    private func beerToAnalyticsParameters(_ beer: Beer) -> [String: NSObject] {
        var parameters = [String: NSObject]()
        parameters["brand"] = beer.brand as NSObject?
        parameters["amount"] = beer.amount as NSObject?
        parameters["value"] = beer.value as NSObject?
        
        return parameters
    }
    
    private func updateWidgetData() {
        let beers = getBeers()
        guard let (mostValuableBeer, economy) = calculateMostValuableBeer(beers: beers),
              let defaults = UserDefaults(suiteName: "group.beerMais") else {
            cleandWidgetData()
            return
        }

        var hasChanges = false
        hasChanges = setWidgetValue(mostValuableBeer.brand, forKey: "BRAND", in: defaults) || hasChanges
        hasChanges = setWidgetValue(amountText(for: mostValuableBeer), forKey: "AMOUNT", in: defaults) || hasChanges
        hasChanges = setWidgetValue("R$ \(formatBeerValueToShow(value: mostValuableBeer.value))", forKey: "VALUE", in: defaults) || hasChanges
        hasChanges = setWidgetValue(String(mostValuableBeer.type), forKey: "TYPE", in: defaults) || hasChanges
        hasChanges = setWidgetValue(String(beers.count), forKey: "BEERS_COUNT", in: defaults) || hasChanges
        let economyText = economy.map { "R$ \(formatBeerValueToShow(value: $0))" }
        hasChanges = setWidgetValue(economyText, forKey: "ECONOMY", in: defaults) || hasChanges

        if hasChanges {
            reloadWidget()
        }
    }

    private func amountText(for beer: Beer) -> String {
        if beer.amount >= 1000 {
            if beer.amount >= 1010 {
                var amountString = String(format: "%.2f", Float(beer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                return "\(amountString) L"
            } else {
                return "1 L"
            }
        } else {
            return "\(beer.amount)ml"
        }
    }

    private func setWidgetValue(_ value: String?, forKey key: String, in defaults: UserDefaults) -> Bool {
        guard let value else {
            guard defaults.object(forKey: key) != nil else { return false }
            defaults.removeObject(forKey: key)
            return true
        }

        guard defaults.string(forKey: key) != value else { return false }
        defaults.set(value, forKey: key)
        return true
    }
    
    private func reloadWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func cleandWidgetData() {
        guard let defaults = UserDefaults(suiteName: "group.beerMais") else { return }

        let keys = ["BRAND", "AMOUNT", "VALUE", "TYPE", "BEERS_COUNT", "ECONOMY"]
        let hasChanges = keys.contains { defaults.object(forKey: $0) != nil }
        keys.forEach { defaults.removeObject(forKey: $0) }
        
        if hasChanges {
            reloadWidget()
        }
    }
}
