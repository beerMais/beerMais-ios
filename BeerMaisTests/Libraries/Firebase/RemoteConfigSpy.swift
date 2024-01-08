//
//  RemoteConfigSpy.swift
//  BeerMaisTests
//
//  Created by José Neves on 07/01/24.
//  Copyright © 2024 joseneves. All rights reserved.
//

import Foundation

import FirebaseRemoteConfig

final class RemoteConfigSpy: RemoteConfigProtocol {
    
    // MARK: - Calls
    
    var fetchAndActivateCalls: [FetchAndActivateCall] = []
    
    var fetchAndActivateWithCompletionHandlerCalls: [FetchAndActivateWithCompletionHandlerCall] = []
    
    var configValueCalls: [ConfigValueCall] = []
    var configValueReturn = RemoteConfigValue()
    
    // MARK: - BeerWorkerProtocol
    
    var configSettings: RemoteConfigSettings = .init()
    
    func fetchAndActivate() {
        fetchAndActivateCalls.append(.init())
    }
    
    func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?) {
        fetchAndActivateWithCompletionHandlerCalls.append(.init(
            completionHandler: completionHandler
        ))
    }
    
    func configValue(forKey key: String?) -> RemoteConfigValue {
        configValueCalls.append(.init(
            key: key,
            returnedValue: configValueReturn
        ))
        
        return configValueReturn
    }
    
    // MARK: - Call structs
    
    struct FetchAndActivateCall {}
    
    struct FetchAndActivateWithCompletionHandlerCall {
        let completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?
    }
    
    struct ConfigValueCall {
        let key: String?
        let returnedValue: RemoteConfigValue
    }
}
