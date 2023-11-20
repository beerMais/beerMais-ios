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


protocol BeerModel: AnyObject, Codable {
    var brand: String? { get set }
    var value: Float { get set }
    var amount: Int16 { get set }
    var type: Int16 { get set }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

public final class Beer: NSManagedObject, BeerModel {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer")
    }

    @NSManaged public var brand: String?
    @NSManaged public var value: Float
    @NSManaged public var amount: Int16
    @NSManaged public var type: Int16
    
    enum CodingKeys: CodingKey {
        case brand
        case value
        case amount
        case type
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.brand = try container.decodeIfPresent(String.self, forKey: .brand)
        self.value = try container.decode(Float.self, forKey: .value)
        self.amount = try container.decode(Int16.self, forKey: .amount)
        self.type = try container.decode(Int16.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(brand, forKey: .brand)
        try container.encode(value, forKey: .value)
        try container.encode(amount, forKey: .amount)
        try container.encode(type, forKey: .type)
    }
}
