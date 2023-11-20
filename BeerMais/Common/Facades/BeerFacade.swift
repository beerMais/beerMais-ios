//
//  BeerFacade.swift
//  BeerMais
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation

import AmplitudeSwift

protocol BeerFacadeProtocol {
    func createBeer(data: [String: Any]) -> Beer?
    
    func orderBeers(_ beers: [Beer]) -> [Beer]
    func getValuePerML(beer: Beer) -> Float
}

final class BeerFacade: BeerFacadeProtocol {
    
    // MARK: - Private properties
    
    private let entityName = "Beer"
    
    // MARK: - BeerFacadeProtocol
    
    func createBeer(data: [String: Any]) -> Beer? {
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
    
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        beers.sorted(by: {
            getValuePerML(beer: $0) < getValuePerML(beer: $1)
        })
    }
    
    func getValuePerML(beer: Beer) -> Float {
        beer.value / Float(beer.amount)
    }
    
    // MARK: - Private methods
    
    func setDataToBeer(beer: Beer, data: [String: Any]) -> Beer {
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
