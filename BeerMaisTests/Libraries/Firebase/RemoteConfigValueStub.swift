//
//  RemoteConfigValueStub.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/01/24.
//  Copyright © 2024 joseneves. All rights reserved.
//

import Foundation

final class RemoteConfigValueStub: RemoteConfigValueProtocol {
    
    var stringValue: String? = .random()
    
    var numberValue: NSNumber = 0
    
    var dataValue: Data = .init()
    
    var boolValue: Bool = .random()
}
