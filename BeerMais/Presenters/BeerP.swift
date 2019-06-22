//
//  BeerPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation

class BeerP {
    private let entityName = "Beer"
    
    func create(data: [String: Any]) -> Beer? {
        if let context = CoreDataP().context {
            
            do {
                let beer = self.setBeerData(beer: Beer(context: context), data: data)
                
                try context.save()
                
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
        return beers.sorted(by: { self.getValuePerML($0) < self.getValuePerML($1) })
    }
    
    func calculateMostValuableByAlcohol(beers: [Beer]) -> [Beer] {
        return beers.filter { $0.alcoholic > 0 }
                    .sorted(by: { self.getValuePerAlcohol($0) < self.getValuePerAlcohol($1) })
    }
    
    func getEconomy(beer1: Beer, beer2: Beer, option: Int) -> Float {
        let value1 = (option == 0) ? self.getValuePerML(beer1) : self.getValuePerAlcohol(beer1)
        let value2 = (option == 0) ? self.getValuePerML(beer2) : self.getValuePerAlcohol(beer2)
        
        return (value2 - value1) * 1000
    }
    
    func deleteBeers() {
        CoreDataP().deleteData(entityName: self.entityName)
    }
    
    func formatValue(value: String) -> Float {
        if (value.count == 0) {
            return 0
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        
        if let number = numberFormatter.number(from: value) {
            return number.floatValue
        } else if let number = numberFormatter.number(from: value.replacingOccurrences(of: ".", with: ",")) {
            return number.floatValue
        }
        
        return 0
    }
    
    func formatValueToShow(value: Float) -> String {
        let valueString = String(format: "%.2f", value)
        return valueString.replacingOccurrences(of: ".", with: ",")
    }
    
    func delete(beer: Beer) {
        CoreDataP().context.delete(beer)
    }
    
    func edit(beer: Beer, data: [String: Any]) {
        _ = self.setBeerData(beer: beer, data: data)
    }
    
    func countBeersWithAlcohol(beers: [Beer]) -> Int {
        let beersWithAlcohol = beers.filter { beer in
            beer.alcoholic > 0
        }
        
        return beersWithAlcohol.count
    }
    
    private func getValuePerML(_ beer: Beer) -> Float {
        return beer.value / Float(beer.amount)
    }
    
    private func setBeerData(beer: Beer, data: [String: Any]) -> Beer {
        beer.amount = data["amount"] as! Int16
        beer.brand = data["brand"] as? String
        beer.value = Float(truncating: data["value"] as! NSNumber)
        beer.type = data["type"] as! Int16
        beer.alcoholic = Float(truncating: data["alcoholic"] as! NSNumber)
        
        return beer
    }
    
    private func getValuePerAlcohol(_ beer: Beer) -> Float {
        return beer.value / ( Float(beer.amount) * beer.alcoholic)
    }
}
