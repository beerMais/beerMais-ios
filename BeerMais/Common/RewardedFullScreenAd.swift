//
//  RewardedFullScreenAd.swift
//  BeerMais
//
//  Created by José Neves on 04/01/26.
//  Copyright © 2026 joseneves. All rights reserved.
//

import SwiftUI

import GoogleMobileAds

@MainActor
final class RewardedFullScreenAd: NSObject, ObservableObject, FullScreenContentDelegate {
    private var rewardedAd: RewardedAd?
    
    @discardableResult
    func loadAd() async -> Bool {
        rewardedAd = nil
        do {
            rewardedAd = try await RewardedAd.load(
                with: SettingsP().getAdMobBeerRewardedID(),
                request: Request()
            )
            rewardedAd?.fullScreenContentDelegate = self
            return true
        } catch {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
            return false
        }
    }
    
    func showAd(from presenter: UIViewController) {
        rewardedAd?.present(from: presenter, userDidEarnRewardHandler: {})
    }
}
