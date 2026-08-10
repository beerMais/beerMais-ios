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
        apiKey: SettingsP().getAmplitudeKey(),
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
    
    static func isFirstLaunch(defaults: UserDefaults = .standard) -> Bool {
        defaults.bool(forKey: self.hasBeenLaunchedBeforeFlag)
    }
    
    static func setFirstLaunch(defaults: UserDefaults = .standard) {
        defaults.set(true, forKey: self.hasBeenLaunchedBeforeFlag)
    }
    
    static private func setInitialData() {
        let beerWorker = BeerWorker()
        
        let beer1 = BeerData(
            brand: "Budweiser",
            value: 2.59,
            amount: 350
        )
        beerWorker.createBeer(data: beer1)
        
        let beer2 = BeerData(
            brand: "Heineken",
            value: 2.79,
            amount: 350
        )
        beerWorker.createBeer(data: beer2)
        
        let beer3 = BeerData(
            brand: "Budweiser",
            value: 2.1,
            amount: 269
        )
        beerWorker.createBeer(data: beer3)
        
        let beer4 = BeerData(
            brand: "Stella Artois",
            value: 2.35,
            amount: 310
        )
        beerWorker.createBeer(data: beer4)
        
        let beer5 = BeerData(
            brand: "Original",
            value: 10.99,
            amount: 1000
        )
        beerWorker.createBeer(data: beer5)
    }
    
    static func incrementAppOpenedCount(defaults: UserDefaults = .standard) {
        guard var appOpenCount = defaults.value(forKey: self.APP_OPEN_COUNT) as? Int else {
            defaults.set(1, forKey: self.APP_OPEN_COUNT)
            return
        }
        appOpenCount += 1
        defaults.set(appOpenCount, forKey: self.APP_OPEN_COUNT)
        self.checkAndAskForReview(defaults: defaults)
    }
    
    static func checkAndAskForReview(defaults: UserDefaults = .standard) {
        guard let appOpenCount = defaults.value(forKey: self.APP_OPEN_COUNT) as? Int else {
            defaults.set(1, forKey: self.APP_OPEN_COUNT)
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
    
    static func logError(
        _ error: Error,
        source: String,
        operation: String,
        properties: [String: Any] = [:]
    ) {
        let nsError = error as NSError
        var eventProperties = properties
        eventProperties["source"] = source
        eventProperties["operation"] = operation
        eventProperties["error_type"] = String(describing: type(of: error))
        eventProperties["error_domain"] = nsError.domain
        eventProperties["error_code"] = nsError.code
        eventProperties["error_description"] = error.localizedDescription
        if let failureReason = nsError.localizedFailureReason {
            eventProperties["failure_reason"] = failureReason
        }
        if let recoverySuggestion = nsError.localizedRecoverySuggestion {
            eventProperties["recovery_suggestion"] = recoverySuggestion
        }
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "error_occurred",
            eventProperties: eventProperties
        ))
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
