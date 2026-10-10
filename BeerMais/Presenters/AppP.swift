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
    
    @discardableResult static func launch() -> Bool {
        let isFirstLaunch = !self.isFirstLaunch()

        if isFirstLaunch {
            self.setFirstLaunch()
            if growthMeasurementEnabled {
                UserDefaults.standard.set(Date(), forKey: "growthFirstLaunchDate")
            }
            AppP.amplitude.setUserId(userId: nil)
        }
        
        self.incrementAppOpenedCount()
        logAppLaunch(isFirstLaunch: isFirstLaunch)
        return isFirstLaunch
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

    static func seedInitialData(using beerWorker: BeerWorkerProtocol) {
        #if DEBUG
        [
            BeerData(brand: "Budweiser", value: 2.59, amount: 350),
            BeerData(brand: "Heineken", value: 2.79, amount: 350),
            BeerData(brand: "Budweiser", value: 2.1, amount: 269),
            BeerData(brand: "Stella Artois", value: 2.35, amount: 310),
            BeerData(brand: "Original", value: 10.99, amount: 1000)
        ].forEach { beerWorker.createBeer(data: $0) }
        #endif
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
    
    private static var growthMeasurementEnabled: Bool {
        #if DEBUG
        return false
        #else
        return Bundle.main.bundleIdentifier == "br.com.joseneves.BeerMais.ios"
            && ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
        #endif
    }

    // Presentation calls this only when a comparison is visible in an active scene.
    @MainActor static func recordFirstComparison() {
        recordFirstComparison(defaults: .standard, now: Date(), enabled: growthMeasurementEnabled) { properties in
            amplitude.track(event: BaseEvent(eventType: "first_comparison_visible", eventProperties: properties))
        }
    }

    @MainActor static func recordFirstComparison(
        defaults: UserDefaults,
        now: Date,
        enabled: Bool,
        track: ([String: Any]) -> Void
    ) {
        guard enabled,
              let firstLaunch = defaults.object(forKey: "growthFirstLaunchDate") as? Date,
              !defaults.bool(forKey: "growthFirstComparisonRecorded") else { return }
        let elapsed = max(0, now.timeIntervalSince(firstLaunch))
        defaults.set(true, forKey: "growthFirstComparisonRecorded")
        track([
            "seconds_since_first_launch": elapsed,
            "within_24_hours": elapsed <= 86400,
            "target": "main_app",
            "guidance_variant": "second_drink_guidance",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            "app_build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        ])
    }

    static func logAppLaunch(isFirstLaunch: Bool = false) {
        AppP.amplitude.track(event: BaseEvent(
            eventType: "app_launch",
            eventProperties: [
                "interface_style": UITraitCollection.current.userInterfaceStyle == .dark ? "dark" : "light",
                "growth_first_launch": isFirstLaunch && growthMeasurementEnabled,
                "growth_eligible": growthMeasurementEnabled && UserDefaults.standard.object(forKey: "growthFirstLaunchDate") != nil,
                "guidance_variant": "second_drink_guidance",
                "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
                "app_build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
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
