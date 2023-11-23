//
//  BeerWorker.swift
//  BeerMais
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation

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
    func calculateMostValuableBeer(beers: [Beer]) -> Beer?
}

final class BeerWorker: BeerWorkerProtocol {
    
    // MARK: - Private properties
    
    private let entityName = "Beer"
    
    // MARK: - BeerWorkerProtocol
    
    @discardableResult func createBeer(data: [String: Any]) -> Beer? {
        guard let context = CoreDataP().context else { return nil }
            
        do {
            let beer = setDataToBeer(beer: Beer(context: context), data: data)
            
            try context.save()
            
            AppP.amplitude.track(event: BaseEvent(
                eventType: "beer_created",
                eventProperties: beerToAnalyticsParameters(beer)
            ))
            
            return beer
        } catch let error {
            print("Could not save. \(error), \(String(describing: error._userInfo))")
            return nil
        }
    }
    
    func getBeers() -> [Beer] {
        guard let beers = CoreDataP().getData(entityName: Beer.entityName) as? [Beer] else {
            return []
        }
        
        return orderBeers(beers)
    }
    
    func edit(beer: Beer, data: [String: Any]) {
        _ = setDataToBeer(beer: beer, data: data)
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_updated",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
    }
    
    func deleteAllBeers() {
        CoreDataP().deleteData(entityName: entityName)
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "all_beers_deleted",
            eventProperties: nil
        ))
    }
    
    func delete(beer: Beer) {
        CoreDataP().context?.delete(beer)
        
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
    
    func calculateMostValuableBeer(beers: [Beer]) -> Beer? {
        guard let mostValuableBeer = orderBeers(beers).first else {
            return nil
        }
        
        // TODO: Please refactory this!
        let defaults = UserDefaults(suiteName: "group.beerMais")
        if let brand = mostValuableBeer.brand {
            defaults?.set(brand, forKey: "BRAND")
        }
        
        var amountText = "\(mostValuableBeer.amount)ml"
        
        if (mostValuableBeer.amount >= 1000) {
            amountText = "1 L"
            
            if (mostValuableBeer.amount >= 1010) {
                var amountString = String(format: "%.2f", Float(mostValuableBeer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            }
        }
        
        defaults?.set(amountText, forKey: "AMOUNT")
        defaults?.set(
            "R$ \(formatBeerValueToShow(value: mostValuableBeer.value))",
            forKey: "VALUE"
        )
        defaults?.set(String(mostValuableBeer.type), forKey: "TYPE")
        defaults?.set(String(beers.count), forKey: "BEERS_COUNT")
        
        if beers.count > 1 {
            let economy = calcEconomyBetweenBeers(beer1: mostValuableBeer, beer2: beers[1])
            
            defaults?.set(
                "R$ \(formatBeerValueToShow(value: economy))",
                forKey: "ECONOMY"
            )
        }
        
        return mostValuableBeer
    }
    
    // MARK: - Private methods
    
    private func setDataToBeer(beer: Beer, data: [String: Any]) -> Beer {
        beer.brand = data["brand"] as? String
        
        if let value = data["value"] as? NSNumber {
            beer.value = Float(truncating: value)
        }
        
        if let amount = data["amount"] as? Int16 {
            beer.amount = amount
        }
        
        if let type = data["type"] as? Int16 {
            beer.type = type
        }
        
        return beer
    }
    
    private func beerToAnalyticsParameters(_ beer: Beer) -> [String: NSObject] {
        var parameters = [String: NSObject]()
        parameters["brand"] = beer.brand as NSObject?
        parameters["amount"] = beer.amount as NSObject?
        parameters["value"] = beer.value as NSObject?
        
        return parameters
    }
}
