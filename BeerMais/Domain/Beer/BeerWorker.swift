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
    @discardableResult func createBeer(data: [String: Any]) -> Beer?
    func getBeers() -> [Beer]
    func edit(beer: Beer, data: [String: Any])
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
    
    @discardableResult func createBeer(data: [String: Any]) -> Beer? {
        guard let context = coreDataWorker.context else { return nil }
        
        let beer = setDataToBeer(beer: Beer(context: context), data: data)
        
        saveContext()
        
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
    
    func edit(beer: Beer, data: [String: Any]) {
        _ = setDataToBeer(beer: beer, data: data)
        saveContext()
        
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
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_deleted",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
    }
    
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        beers.sorted(by: {
            getValuePerML(beer: $0) < getValuePerML(beer: $1)
        })
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
            cleandWidgetData()
            return nil
        }
        
        let economy: Float? = beers.count > 1 ? calcEconomyBetweenBeers(beer1: mostValuableBeer, beer2: beers[1]) : nil
        
        // TODO: Please refactory this!
        guard let defaults = UserDefaults(suiteName: "group.beerMais") else {
            return (mostValuableBeer, economy)
        }
        
        if let brand = mostValuableBeer.brand {
            defaults.set(brand, forKey: "BRAND")
        }
        
        let amountText: String
        if mostValuableBeer.amount >= 1000 {
            if mostValuableBeer.amount >= 1010 {
                var amountString = String(format: "%.2f", Float(mostValuableBeer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            } else {
                amountText = "1 L"
            }
        } else {
            amountText = "\(mostValuableBeer.amount)ml"
        }
        defaults.set(amountText, forKey: "AMOUNT")
        
        defaults.set(
            "R$ \(formatBeerValueToShow(value: mostValuableBeer.value))",
            forKey: "VALUE"
        )
        defaults.set(String(mostValuableBeer.type), forKey: "TYPE")
        defaults.set(String(beers.count), forKey: "BEERS_COUNT")
    
        if let economy {
            defaults.set(
                "R$ \(formatBeerValueToShow(value: economy))",
                forKey: "ECONOMY"
            )
            reloadWidget()
        }
        
        return (mostValuableBeer, economy)
    }
    
    // MARK: - Private methods
    
    private func setDataToBeer(beer: Beer, data: [String: Any]) -> Beer {
        beer.brand = data["brand"] as? String
        
        if let value = data["value"] as? NSNumber {
            beer.value = Float(truncating: value)
        } else if let value = data["value"] as? Float {
            beer.value = value
        }
        
        if let amount = data["amount"] as? Int16 {
            beer.amount = amount
        } else if let amount = data["amount"] as? NSNumber {
            beer.amount = amount.int16Value
        } else if let amount = data["amount"] as? String {
            beer.amount = Int16(amount) ?? 0
        }
        
        if let type = data["type"] as? Int16 {
            beer.type = type
        } else if let type = data["type"] as? NSNumber {
            beer.type = type.int16Value
        }
        
        return beer
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
    
    private func reloadWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func cleandWidgetData() {
        if let defaults = UserDefaults(suiteName: "group.beerMais") {
            for key in defaults.dictionaryRepresentation().keys {
                defaults.removeObject(forKey: key)
            }
        }
        
        reloadWidget()
    }
}
