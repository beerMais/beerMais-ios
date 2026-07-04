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
    
    nonisolated(unsafe) static let shared: CoreDataWorkerProtocol = {
        CoreDataWorker()
    }()
    
    public var context: NSManagedObjectContext?
    
    init() {
        self.context = MainActor.assumeIsolated {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    func getData(entityName: String) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context?.fetch(fetchRequest) ?? []
        } catch {
            AppP.logError(
                error,
                source: "CoreDataWorker",
                operation: "getData",
                properties: ["entityName": entityName]
            )
            
            return []
        }
    }
    
    func deleteData(entityName: String) {
        guard let context else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        } catch {
            AppP.logError(
                error,
                source: "CoreDataWorker",
                operation: "deleteData",
                properties: ["entityName": entityName]
            )
        }
    }
}
