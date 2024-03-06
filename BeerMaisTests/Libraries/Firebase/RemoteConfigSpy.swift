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
    var configValueCacheReturn = [String: RemoteConfigValueProtocol]()
    
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
    
    func configValue(key: String?) -> RemoteConfigValueProtocol {
        
        var configValueReturn: RemoteConfigValueProtocol = RemoteConfigValueStub()
        
        if let key,
           let configValueCache = configValueCacheReturn[key] {
            configValueReturn = configValueCache
        }
        
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
        let returnedValue: RemoteConfigValueProtocol
    }
}
