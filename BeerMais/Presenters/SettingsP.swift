//
//  SettingsP.swift
//  BeerMais
//
//  Created by Jose Neves on 21/01/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import Foundation

class SettingsP {
    func getAdMobId() -> String {
        var adMobId = ""
        
        if let dict = self.getDictionary() {
            adMobId = dict["AdMobID"] as! String
        }
        
        return adMobId
    }
    
    func getAdMobBeerBannerID() -> String {
        var adMobBeerBannerID = ""
        
        if let dict = self.getDictionary() {
            adMobBeerBannerID = dict["AdMobBeerBannerID"] as! String
        }
        
        return adMobBeerBannerID
    }
    
    private func getDictionary() -> NSDictionary? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        
        return nil
    }
}
