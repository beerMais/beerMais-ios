//
//  AppPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import Foundation
import StoreKit
@preconcurrency import AmplitudeSwift
import FirebaseRemoteConfig


final class AppP {
    private static let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
    private static let APP_OPEN_COUNT = "APP_OPEN_COUNT"
    
    public static let amplitude: Amplitude = Amplitude(configuration: Configuration(
        apiKey: SettingsP.getAmplitudeKey(),
        autocapture: .all
    ))
    
    @MainActor public static let remoteConfig: RemoteConfigProtocol = RemoteConfig.remoteConfig()
    
    static func launch() {
        
        if (!self.isFirstLaunch()) {
            self.setFirstLaunch()
            
            AppP.amplitude.setUserId(userId: nil)
            
            #if DEBUG
                self.setInitialData()
            #endif
        }
        
        self.incrementAppOpenedCount()
        logAppLaunch()
    }
    
    @MainActor static func launchRemoteConfig() {
        let settings = RemoteConfigSettings()
        
        #if DEBUG
            settings.minimumFetchInterval = 0
        #endif
        
        AppP.remoteConfig.configSettings = settings
        AppP.remoteConfig.fetchAndActivate()
    }
    
    static func isFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: self.hasBeenLaunchedBeforeFlag)
    }
    
    static func setFirstLaunch() {
        UserDefaults.standard.set(true, forKey: self.hasBeenLaunchedBeforeFlag)
    }
    
    static private func setInitialData() {
        let beerWorker = BeerWorker()
        
        var beer1 = BeerData(
            brand: "Budweiser",
            value: 2.59,
            amount: 350
        )
        beerWorker.createBeer(data: beer1)
        
        var beer2 = BeerData(
            brand: "Heineken",
            value: 2.79,
            amount: 350
        )
        beerWorker.createBeer(data: beer2)
        
        var beer3 = BeerData(
            brand: "Budweiser",
            value: 2.1,
            amount: 269
        )
        beerWorker.createBeer(data: beer3)
        
        var beer4 = BeerData(
            brand: "Stella Artois",
            value: 2.35,
            amount: 310
        )
        beerWorker.createBeer(data: beer4)
        
        var beer5 = BeerData(
            brand: "Original",
            value: 10.99,
            amount: 1000
        )
        beerWorker.createBeer(data: beer5)
    }
    
    static func incrementAppOpenedCount() {
        guard var appOpenCount = UserDefaults.standard.value(forKey: self.APP_OPEN_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: self.APP_OPEN_COUNT)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: self.APP_OPEN_COUNT)
        self.checkAndAskForReview()
    }
    
    static func checkAndAskForReview() {
        guard let appOpenCount = UserDefaults.standard.value(forKey: self.APP_OPEN_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: self.APP_OPEN_COUNT)
            return
        }
        
        switch appOpenCount {
        case 10,50:
            AppP().requestReview()
        case _ where appOpenCount%100 == 0 :
            AppP().requestReview()
        default:
            break;
        }
        
    }
    
    static func logAppLaunch() {
        AppP.amplitude.track(event: BaseEvent(
            eventType: "app_launch",
            eventProperties: [
                "interface_style": UITraitCollection.current.userInterfaceStyle == .dark ? "dark" : "light"
            ]
        ))
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
