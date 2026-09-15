//
//  AppDelegate.swift
//  BeerMais
//
//  Created by Jose Neves on 25/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit
import UserNotifications
import WidgetKit

import FirebaseCore
import FirebaseMessaging
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private(set) var isFirstLaunch = false

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        isFirstLaunch = AppP.launch()
        FirebaseApp.configure()
        MobileAds.shared.start()
        Messaging.messaging().delegate = self
        requestNotificationAuthorization(application: application)
        AppP.launchRemoteConfig()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func requestNotificationAuthorization(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {}

extension AppDelegate: @preconcurrency MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        #if DEBUG
        print("Firebase registration token: \(fcmToken ?? "")")
        #endif
    }
}
