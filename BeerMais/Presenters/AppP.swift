//
//  AppPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation

class AppP {
    private static let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
    
    static func launch() {
        if (!self.isFirstLaunch()) {
            self.setFirstLaunch()
//            self.setInitialData()
        }
    }
    
    static func isFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: self.hasBeenLaunchedBeforeFlag)
    }
    
    static func setFirstLaunch() {
        UserDefaults.standard.set(true, forKey: self.hasBeenLaunchedBeforeFlag)
        UserDefaults.standard.synchronize()
    }
    
    static private func setInitialData() {
        let beerPresenter = BeerP()
        
        var beer1 = [String: Any]()
        beer1["amount"] = Int16(350)
        beer1["brand"] = "Budweiser"
        beer1["value"] = 2.59
        beer1["type"] = Int16(1)
        _ = beerPresenter.create(data: beer1)
        
        var beer2 = [String: Any]()
        beer2["amount"] = Int16(350)
        beer2["brand"] = "Heineken"
        beer2["value"] = 2.79
        beer2["type"] = Int16(1)
        _ = beerPresenter.create(data: beer2)
        
        var beer3 = [String: Any]()
        beer3["amount"] = Int16(269)
        beer3["brand"] = "Budweiser"
        beer3["value"] = 2.10
        beer3["type"] = Int16(1)
        _ = beerPresenter.create(data: beer3)
        
        var beer4 = [String: Any]()
        beer4["amount"] = Int16(310)
        beer4["brand"] = "Stella Artois"
        beer4["value"] = 2.35
        beer4["type"] = Int16(1)
        _ = beerPresenter.create(data: beer4)
        
        var beer5 = [String: Any]()
        beer5["amount"] = Int16(1000)
        beer5["brand"] = "Original"
        beer5["value"] = 10.99
        beer5["type"] = Int16(2)
        _ = beerPresenter.create(data: beer5)
    }
}
