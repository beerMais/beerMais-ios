//
//  BeerModel+Mock.swift
//  BeerMaisTests
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import CoreData

extension Beer {
    static func mock() -> Beer {
        var beer1 = [String: Any]()
        beer1["amount"] = Int16(350)
        beer1["brand"] = "Budweiser"
        beer1["value"] = 2.59
        beer1["type"] = Int16(1)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = Self.setUpInMemoryManagedObjectContext()
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: beer1, options: [])
        return try! decoder.decode(Beer.self, from: jsonData)
    }
    
    static func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        persistentStoreCoordinator.name = "BeerMais"
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}

