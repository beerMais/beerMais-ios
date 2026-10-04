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
    @Binding var height: CGFloat
    
    init(_ adSize: AdSize, height: Binding<CGFloat>) {
        self.adSize = adSize
        _height = height
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = SettingsP().getAdMobBeerBannerID()
        banner.adSizeDelegate = context.coordinator
        banner.load(Request())
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        context.coordinator.parent = self
        guard !isAdSizeEqualToSize(size1: uiView.adSize, size2: adSize) else { return }
        // The SDK requests a resized creative when adSize changes; do not load twice.
        uiView.adSize = adSize
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: BannerView, context: Context) -> CGSize? {
        CGSize(width: cgSize(for: adSize).width, height: height)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    static func dismantleUIView(_ uiView: BannerView, coordinator: Coordinator) {
        uiView.adSizeDelegate = nil
        coordinator.isActive = false
    }

    final class Coordinator: NSObject, AdSizeDelegate {
        var parent: BannerViewContainer
        var isActive = true

        init(_ parent: BannerViewContainer) { self.parent = parent }

        func adView(_ bannerView: BannerView, willChangeAdSizeTo size: AdSize) {
            let height = cgSize(for: size).height
            guard isActive, height.isFinite, height > 0 else { return }
            parent.height = height
        }
    }
}

/// Measures the actual row/sheet width and waits for interactive resizing to settle.
struct AdaptiveBannerView: View {
    @State private var availableWidth: CGFloat = 0
    @State private var bannerWidth: CGFloat = 0
    @State private var bannerHeight: CGFloat = 100

    var body: some View {
        // Inline ads belong in scroll views; their loaded height comes from the SDK.
        let adSize = inlineAdaptiveBanner(width: max(bannerWidth, 1), maxHeight: 100)
        Color.clear
            .frame(height: bannerHeight)
            .frame(maxWidth: .infinity)
            .overlay {
                if bannerWidth > 0 && bannerWidth == availableWidth {
                    BannerViewContainer(adSize, height: $bannerHeight)
                        // A resized slot needs a fresh request, including while an old load is pending.
                        .id(bannerWidth)
                        .frame(width: cgSize(for: adSize).width, height: bannerHeight)
                }
            }
            .onGeometryChange(for: CGFloat.self) { geometry in
                max(0, geometry.size.width.rounded(.down))
            } action: { width in
                availableWidth = width
            }
            .task(id: availableWidth) {
                guard availableWidth > 0 else { return }
                do {
                    try await Task.sleep(for: .milliseconds(250))
                    bannerHeight = 100
                    bannerWidth = availableWidth
                } catch { /* A newer width superseded this update. */ }
            }
    }
}
