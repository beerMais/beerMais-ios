//
//  DonateView.swift
//  BeerMais
//
//  Created by José Neves on 19/06/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

struct DonateView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isPurchasing = false
    @State private var showsNotice = false
    @State private var notice: LocalizedStringKey = "donationSuccess"
    @State private var windowReference = DonationWindowReference()
#if !(DEBUG_APPCLIP || APPCLIP)
    @StateObject private var rewardedAd = RewardedFullScreenAd()
#endif

    var body: some View {
        VStack {
            Text("donationDescription")
            
            LazyVGrid(columns: dynamicTypeSize.isAccessibilitySize
                      ? [GridItem(.flexible())]
                      : [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach($viewModel.donates, id: \.name) { product in
                    DonateProductView(product: product, action: {
                        purchase(product.wrappedValue)
                    })
                }
            }
#if !(DEBUG_APPCLIP || APPCLIP)
            Button("watchSupportAd", action: watchSupportAd)
                .frame(minHeight: 44)
#endif
        }
        .disabled(isPurchasing)
        .background(WindowReader { windowReference.window = $0 })
        .overlay {
            if isPurchasing {
                ProgressView()
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .alert(notice, isPresented: $showsNotice) {}
    }

    private func purchase(_ product: DonateProduct) {
        guard !isPurchasing else { return }
        isPurchasing = true
        Task { @MainActor in
            defer { isPurchasing = false }
            switch await viewModel.buyProduct(product) {
            case .success: notice = "donationSuccess"
            case .cancelled: return
            case .pending: notice = "donationPending"
            case .failed: notice = "donationFailed"
            }
            showsNotice = true
        }
    }

#if !(DEBUG_APPCLIP || APPCLIP)
    private func watchSupportAd() {
        guard !isPurchasing else { return }
        isPurchasing = true
        Task { @MainActor in
            defer { isPurchasing = false }
            guard await rewardedAd.loadAd(),
                  let root = windowReference.window?.rootViewController else {
                notice = "supportAdUnavailable"
                showsNotice = true
                return
            }
            var presenter = root
            while let presented = presenter.presentedViewController {
                presenter = presented
            }
            rewardedAd.showAd(from: presenter)
        }
    }
#endif
}

//#Preview {
//    AboutView()
//}

struct DonateProductView: View {
    
    @Binding var product: DonateProduct
    var action: () -> Void
    
    private var image: Image {
        switch product.type {
        case .small:
            BeerImage.iconBeerCan100UI
        case .medium:
            BeerImage.iconBeerBottle100UI
        case .large:
            BeerImage.iconBeerBottles100UI
        }
    }
    
    private var container: some View {
        VStack {
            Spacer(minLength: 8)
            
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 72, maxHeight: 72)
                .clipped()
            
            Text(product.name)
                .font(.body)
            if let priceFormatted = product.priceFormatted {
                Text(priceFormatted)
                    .font(.body)
            }
            
            Spacer(minLength: 8)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    var body: some View {
        Button(action: action) {
            if #available(iOS 26.0, *) {
                container
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))

            } else {
                container
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 0.5)
                    }
            }
        }
        .tint(Color(UIColor.label))
    }
}

/// Reports this view's window instead of selecting an arbitrary connected scene.
private struct WindowReader: UIViewRepresentable {
    var onChange: (UIWindow?) -> Void

    final class ReaderView: UIView {
        var onChange: ((UIWindow?) -> Void)?
        override func didMoveToWindow() {
            super.didMoveToWindow()
            onChange?(window)
        }
    }

    func makeUIView(context: Context) -> ReaderView {
        let view = ReaderView()
        view.onChange = { window in
            DispatchQueue.main.async { onChange(window) }
        }
        return view
    }

    func updateUIView(_ uiView: ReaderView, context: Context) {}
}

@MainActor
private final class DonationWindowReference {
    weak var window: UIWindow?
}
