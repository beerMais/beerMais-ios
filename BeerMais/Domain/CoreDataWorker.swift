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

    init(modelName: String = "BeerMais", inMemory: Bool = false) {
        container = NSPersistentContainer(name: modelName)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.persistentStoreDescriptions.forEach {
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
        let beer = Beer(context: context)
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

    init(persistenceController: PersistenceController = PersistenceController()) {
        self.persistenceController = persistenceController
        let beerRepository = CoreDataBeerRepository(persistenceController: persistenceController)
        self.beerRepository = beerRepository
        self.beerWorker = BeerWorker(repository: beerRepository)
    }

    static let preview = AppDependencies(persistenceController: PersistenceController(inMemory: true))
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
