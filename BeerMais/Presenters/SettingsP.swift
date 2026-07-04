//
//  SettingsP.swift
//  BeerMais
//
//  Created by Jose Neves on 21/01/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import Foundation

final class SettingsP {
    private let settingsDictionary: [String: String] = {
        guard let path = Bundle.main.path(forResource: "Settings", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
            return [:]
        }

        return dictionary
    }()

    func getAdMobId() -> String {
        settingsDictionary["AdMobID"] ?? ""
    }
    
    func getAdMobBeerBannerID() -> String {
        settingsDictionary["AdMobBeerBannerID"] ?? ""
    }
    
    func getAdMobBeerRewardedID() -> String {
        settingsDictionary["AdMobBeerRewardedID"] ?? ""
    }
    
    func getAmplitudeKey() -> String {
        settingsDictionary["AmplitudeKey"] ?? ""
    }
}
