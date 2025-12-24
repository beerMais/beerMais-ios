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
    
#if !(DEBUG_APPCLIP || APPCLIP)
    private let successFeedbackView = SuccessFeedbackView()
    private let loadingView = LoadingView()
#endif
    
    var body: some View {
        VStack {
            Text("Se você já economizou usando o Beer Mais na hora de escolher a melhor bebida e deseja contibuir com a manutenção do app, qualquer valor é de grande ajuda 🍻")
            
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach($viewModel.donates, id: \.name) { product in
                    DonateProductView(product: product, action: {
#if !(DEBUG_APPCLIP || APPCLIP)
                        loadingView.show()
                        Task {
                            let isSucceed = await viewModel.buyProduct(product.wrappedValue)
                            
                            if isSucceed {
                                loadingView.hide()
                                successFeedbackView.show()
                            } else {
                                let rewardedViewModel = RewardedFullScreenAd()
                                await rewardedViewModel.loadAd()
                                
                                loadingView.hide()
                                rewardedViewModel.showAd()
                                
                            }
                        }
#else
                        Task {
                            await viewModel.buyProduct(product.wrappedValue)
                        }
#endif
                    })
                }
            }
        }
    }
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
                .frame(width: UIScreen.main.bounds.width * 0.2)
                .clipped()
            
            Text(product.name)
                .font(.system(size: 16))
            if let priceFormatted = product.priceFormatted {
                Text(priceFormatted)
                    .font(.system(size: 16))
            }
            
            Spacer(minLength: 8)
        }
        .frame(minWidth: UIScreen.main.bounds.width * 0.29)
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
