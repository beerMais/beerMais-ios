//
//  Beer+CoreDataClass.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//
//

import Foundation
import CoreData

public final class Beer: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer")
    }

    @NSManaged public var brand: String?
    @NSManaged public var value: Float
    @NSManaged public var amount: Int16
    @NSManaged public var type: Int16
}
