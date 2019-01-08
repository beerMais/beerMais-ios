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
}
