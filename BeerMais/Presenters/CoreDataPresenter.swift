//
//  CoreDataPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import CoreData
import UIKit

class CoreDataPresenter {
    var context: NSManagedObjectContext!
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func getData(entityName: String) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Get all data in \(entityName) error : \(error) \(error.userInfo)")
            return []
        }
    }
    
    func deleteData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try self.context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    self.context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all data in \(entityName) error : \(error) \(error.userInfo)")
        }
    }
    
}
