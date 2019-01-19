//
//  BeerPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation

class BeerPresenter {
    private let entityName = "Beer"
    
    func create(data: [String: Any]) -> Beer? {
        if let context = CoreDataPresenter().context {
            
            do {
                let model = Beer(context: context)
                model.amount = data["amount"] as! Int16
                model.brand = data["brand"] as? String
                model.value = Float(truncating: data["value"] as! NSNumber)
                model.type = data["type"] as! Int16
                
                try context.save()
                
                return model
            } catch let error {
                print("Could not save. \(error), \(String(describing: error._userInfo))")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getBeers(completion: @escaping([Beer]) -> Void) {
        if let data = CoreDataPresenter().getData(entityName: self.entityName) as? [Beer] {
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
        CoreDataPresenter().deleteData(entityName: self.entityName)
    }
    
    func formatValue(value: String) -> Float {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let number = numberFormatter.number(from: value)!
        return number.floatValue
    }
    
    func delete(beer: Beer) {
        CoreDataPresenter().context.delete(beer)
    }
    
    private func getValuePerML(value: Float, amount: Int16) -> Float {
        return value / Float(amount)
    }
}
