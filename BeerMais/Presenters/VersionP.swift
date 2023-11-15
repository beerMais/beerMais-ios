//
//  VersionP.swift
//  BeerMais
//
//  Created by José Neves on 02/04/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import Foundation

final class VersionP {
    func getAppName() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return version
        }
        return "Beer Mais"
    }
    
    static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0"
    }
}
