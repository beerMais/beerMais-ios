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
    func configValue(forKey key: String?) -> RemoteConfigValue
}

extension RemoteConfig: RemoteConfigProtocol {
    public func fetchAndActivate() {
        fetchAndActivate(completionHandler: nil)
    }
}
