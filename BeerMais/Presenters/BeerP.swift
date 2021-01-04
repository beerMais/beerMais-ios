//
//  BeerPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation
import Amplitude


class BeerP {
    private let entityName = "Beer"
    
    func create(data: [String: Any]) -> Beer? {
        if let context = CoreDataP().context {
            
            do {
                let beer = self.setBeerData(beer: Beer(context: context), data: data)
                
                try context.save()
                
                Amplitude.instance().logEvent("beer_created", withEventProperties: beerToAnalyticsParameters(beer))
                
                return beer
            } catch let error {
                print("Could not save. \(error), \(String(describing: error._userInfo))")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getBeers(completion: @escaping([Beer]) -> Void) {
        if let data = CoreDataP().getData(entityName: self.entityName) as? [Beer] {
            completion(data)
        }
    }
    
    func calculateMostValuable(beers: [Beer]) -> [Beer] {
        return beers.sorted(by: { self.getValuePerML(value: $0.value, amount: $0.amount) < self.getValuePerML(value: $1.value, amount: $1.amount) })
    }
    
    func getEconomy(beer1: Beer, beer2: Beer) -> Float {
        let value1 = self.getValuePerML(value: beer1.value, amount: beer1.amount)
        let value2 = self.getValuePerML(value: beer2.value, amount: beer2.amount)
        
        return (value2 - value1) * 1000
    }
    
    func deleteBeers() {
        CoreDataP().deleteData(entityName: self.entityName)
        
        Amplitude.instance().logEvent("all_beers_deleted", withEventProperties: nil)
    }
    
    func formatValueToShow(value: Float) -> String {
        let valueString = String(format: "%.2f", value)
        return valueString.replacingOccurrences(of: ".", with: ",")
    }
    
    func delete(beer: Beer) {
        CoreDataP().context.delete(beer)
        
        Amplitude.instance().logEvent("beer_deleted", withEventProperties: beerToAnalyticsParameters(beer))
    }
    
    func edit(beer: Beer, data: [String: Any]) {
        _ = self.setBeerData(beer: beer, data: data)
        
        Amplitude.instance().logEvent("beer_updated", withEventProperties: beerToAnalyticsParameters(beer))
    }
    
    func getValuePerML(value: Float, amount: Int16) -> Float {
        return value / Float(amount)
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
        beer.amount = data["amount"] as! Int16
        beer.brand = data["brand"] as? String
        beer.value = Float(truncating: data["value"] as! NSNumber)
        beer.type = data["type"] as! Int16
        
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
