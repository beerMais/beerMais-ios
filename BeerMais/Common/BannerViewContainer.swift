//
//  BannerViewContainer.swift
//  BeerMais
//
//  Created by Jose Neves on 30/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import SwiftUI

import GoogleMobileAds

struct BannerViewContainer: UIViewRepresentable {
    typealias UIViewType = BannerView
    let adSize: AdSize
    
    init(_ adSize: AdSize) {
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = SettingsP().getAdMobBeerBannerID()
        banner.load(Request())
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
}
