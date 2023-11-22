//
//  BeerPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation
import AmplitudeSwift


final class BeerP {
    private let entityName = "Beer"
    
    func getBeers(completion: @escaping([Beer]) -> Void) {
        if let beers = CoreDataP().getData(entityName: self.entityName) as? [Beer] {
            completion(BeerFacade().orderBeers(beers))
        } else {
            completion([])
        }
    }
    
    func deleteBeers() {
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
    
    func edit(beer: Beer, data: [String: Any]) {
        _ = self.setBeerData(beer: beer, data: data)
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_updated",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
    }
    
    static func getValueFromString(value: String) -> Float {
        var amountWithPrefix = value
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSMakeRange(0, amountWithPrefix.count),
                                                          withTemplate: "")

        let floatValue = (amountWithPrefix as NSString).floatValue
        return NSNumber(value: (floatValue / 100)).floatValue
    }
    
    private func setBeerData(beer: Beer, data: [String: Any]) -> Beer {
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
