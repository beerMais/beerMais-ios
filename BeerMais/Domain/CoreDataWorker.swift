//
//  CoreDataWorker.swift
//  BeerMais
//
//  Created by José Neves on 22/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol CoreDataWorkerProtocol {
    var context: NSManagedObjectContext? { get }
    
    func getData(entityName: String) -> [Any]
    func deleteData(entityName: String)
}

final class CoreDataWorker: CoreDataWorkerProtocol {
    
    static var shared: CoreDataWorkerProtocol = {
        CoreDataWorker()
    }()
    
    public var context: NSManagedObjectContext?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func getData(entityName: String) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context?.fetch(fetchRequest) ?? []
        } catch let error as NSError {
            print("Get all data in \(entityName) error : \(error) \(error.userInfo)")
            return []
        }
    }
    
    func deleteData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(fetchRequest) ?? []
            for managedObject in results {
                if let managedObjectData = managedObject as? NSManagedObject {
                    context?.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all data in \(entityName) error : \(error) \(error.userInfo)")
        }
    }
}
