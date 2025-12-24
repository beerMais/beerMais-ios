//
//  RewardedFullScreenAd.swift
//  BeerMais
//
//  Created by José Neves on 04/01/26.
//  Copyright © 2026 joseneves. All rights reserved.
//

import SwiftUI

import GoogleMobileAds

final class RewardedFullScreenAd: NSObject, ObservableObject, FullScreenContentDelegate {
    private var rewardedAd: RewardedAd?
    
    func loadAd() async {
        do {
            rewardedAd = try await RewardedAd.load(
                with: SettingsP().getAdMobBeerRewardedID(),
                request: Request()
            )
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        }
    }
    
    func showAd() {
        rewardedAd?.present(from: nil, userDidEarnRewardHandler: {})
    }
}
