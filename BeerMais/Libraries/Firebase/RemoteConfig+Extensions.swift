//
//  RemoteConfig+Extensions.swift
//  BeerMais
//
//  Created by José Neves on 08/01/24.
//  Copyright © 2024 joseneves. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

public protocol RemoteConfigProtocol: AnyObject {
    
    var configSettings: RemoteConfigSettings { get set }
    
    func fetchAndActivate()
    func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?)
    func configValue(key: String?) -> RemoteConfigValueProtocol
}

extension RemoteConfig: RemoteConfigProtocol {
    
    public func fetchAndActivate() {
        fetchAndActivate(completionHandler: nil)
    }
    
    public func configValue(key: String?) -> RemoteConfigValueProtocol {
        configValue(forKey: key)
    }
}

public protocol RemoteConfigValueProtocol {
    
    var stringValue: String? { get }
    var numberValue: NSNumber { get }
    var dataValue: Data { get }
    var boolValue: Bool { get }
}

extension RemoteConfigValue: RemoteConfigValueProtocol {}
