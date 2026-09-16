//
//  CoreDataWorker.swift
//  BeerMais
//
//  Created by José Neves on 22/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import CoreData
import Foundation
import SwiftUI

final class PersistenceController {
    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(
        modelName: String = "BeerMais",
        inMemory: Bool = false,
        managedObjectModel: NSManagedObjectModel? = nil,
        storeURL: URL? = nil
    ) {
        if let managedObjectModel {
            container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        } else {
            container = NSPersistentContainer(name: modelName)
        }
        if let storeURL {
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        }

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = false
            $0.shouldMigrateStoreAutomatically = true
            $0.shouldInferMappingModelAutomatically = true
        }
        container.loadPersistentStores { _, error in
            if let error {
                AppP.logError(error, source: "PersistenceController", operation: "loadPersistentStores")
            }
        }

        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
}

protocol BeerRepository {
    func fetchBeers() -> [Beer]
    @discardableResult func create(data: BeerData) -> Beer?
    @discardableResult func update(beer: Beer, data: BeerData) -> Bool
    @discardableResult func delete(beer: Beer) -> Bool
    @discardableResult func deleteAll() -> Bool
}

final class CoreDataBeerRepository: BeerRepository {
    private let context: NSManagedObjectContext

    init(persistenceController: PersistenceController) {
        context = persistenceController.viewContext
    }

    func fetchBeers() -> [Beer] {
        do {
            return try context.fetch(Beer.fetchRequest())
        } catch {
            AppP.logError(error, source: "CoreDataBeerRepository", operation: "fetchBeers")
            return []
        }
    }

    @discardableResult func create(data: BeerData) -> Beer? {
        guard let entity = NSEntityDescription.entity(forEntityName: Beer.entityName, in: context) else { return nil }
        let beer = Beer(entity: entity, insertInto: context)
        apply(data: data, to: beer)
        return save() ? beer : nil
    }

    @discardableResult func update(beer: Beer, data: BeerData) -> Bool {
        apply(data: data, to: beer)
        return save()
    }

    @discardableResult func delete(beer: Beer) -> Bool {
        context.delete(beer)
        return save()
    }

    @discardableResult func deleteAll() -> Bool {
        // Batch deletion is SQLite-only. Previews can use an in-memory store.
        if context.persistentStoreCoordinator?.persistentStores.contains(where: { $0.type != NSSQLiteStoreType }) == true {
            do {
                try context.fetch(Beer.fetchRequest()).forEach { context.delete($0) }
                return save()
            } catch {
                context.rollback()
                AppP.logError(error, source: "CoreDataBeerRepository", operation: "deleteAll")
                return false
            }
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Beer.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            return true
        } catch {
            AppP.logError(error, source: "CoreDataBeerRepository", operation: "deleteAll")
            return false
        }
    }

    private func apply(data: BeerData, to beer: Beer) {
        beer.brand = data.brand
        beer.value = data.value
        beer.amount = data.amount
        beer.type = data.type
    }

    private func save() -> Bool {
        guard context.hasChanges else { return true }

        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            AppP.logError(error, source: "CoreDataBeerRepository", operation: "save")
            return false
        }
    }
}

struct AppDependencies: @unchecked Sendable {
    let persistenceController: PersistenceController
    let beerRepository: BeerRepository
    let beerWorker: BeerWorkerProtocol

    init(
        persistenceController: PersistenceController = PersistenceController(),
        widgetDefaults: UserDefaults? = UserDefaults(suiteName: "group.beerMais")
    ) {
        self.persistenceController = persistenceController
        let beerRepository = CoreDataBeerRepository(persistenceController: persistenceController)
        self.beerRepository = beerRepository
        self.beerWorker = BeerWorker(repository: beerRepository, widgetDefaults: widgetDefaults)
    }

    static let preview = AppDependencies(persistenceController: PersistenceController(inMemory: true), widgetDefaults: nil)
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue = AppDependencies.preview
}

extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
