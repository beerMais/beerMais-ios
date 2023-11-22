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
    
    static let managedObjectModel: NSManagedObjectModel = {
        NSManagedObjectModel.mergedModel(from: [Bundle(for: Beer.self)])!
    }()
    
    static var inMemoryManagedObjectContext: NSPersistentContainer = {
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("store")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        description.shouldAddStoreAsynchronously = false
        description.type = NSInMemoryStoreType

        let persistentContainer = NSPersistentContainer(name: "BeerMais", managedObjectModel: Beer.managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, _ in }

        return persistentContainer
    }()

    static func mock() -> Beer {
        Beer(context: Self.inMemoryManagedObjectContext.viewContext)
    }
}
