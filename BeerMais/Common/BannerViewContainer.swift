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
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        guard uiView.adSize.size != adSize.size else { return }
        // The SDK requests a resized creative when adSize changes; do not load twice.
        uiView.adSize = adSize
    }
}

/// Measures the actual row/sheet width and waits for interactive resizing to settle.
struct AdaptiveBannerView: View {
    @State private var availableWidth: CGFloat = 0
    @State private var bannerWidth: CGFloat = 0

    var body: some View {
        let adSize = largeAnchoredAdaptiveBanner(width: max(bannerWidth, 1))
        Color.clear
            .frame(height: bannerWidth > 0 ? adSize.size.height : 1)
            .frame(maxWidth: .infinity)
            .overlay {
                if bannerWidth > 0 {
                    BannerViewContainer(adSize)
                        .frame(width: adSize.size.width, height: adSize.size.height)
                }
            }
            .clipped()
            .onGeometryChange(for: CGFloat.self) { geometry in
                max(0, geometry.size.width.rounded(.down))
            } action: { width in
                availableWidth = width
            }
            .task(id: availableWidth) {
                guard availableWidth > 0 else { return }
                do {
                    try await Task.sleep(for: .milliseconds(250))
                    bannerWidth = availableWidth
                } catch { /* A newer width superseded this update. */ }
            }
    }
}
