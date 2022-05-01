//
//  BeerAdView.swift
//  BeerMais
//
//  Created by Jose Neves on 30/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class BeerAdView: GADBannerView {
    
    static func build(with rootViewController: UIViewController) -> BeerAdView {
        let view = BeerAdView()
        view.adUnitID = SettingsP().getAdMobBeerBannerID()
        view.rootViewController = rootViewController
        view.load(GADRequest())
        
        #if DEBUG_APPCLIP || APPCLIP
            view.isHidden = false
        #endif
        
        return view
    }
}
