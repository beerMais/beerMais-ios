//
//  DeleteAllView.swift
//  BeerMais
//
//  Created by José Neves on 16/11/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct DeleteAllView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                
                Text("deleteTitle")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                Text("deleteBeerAlert")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                HStack {
                    let deleteButton = Button("delete") {
                        BeerWorker().deleteAllBeers()
                        dismiss()
                    }
                    .buttonBorderShape(.roundedRectangle)
                    if #available(iOS 26.0, *) {
                        deleteButton
                            .buttonStyle(.glassProminent)
                    } else {
                        deleteButton
                    }
                }
                
                Spacer()
                
                let adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
                BannerViewContainer(adSize)
                    .frame(width: adSize.size.width, height: adSize.size.height)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("backScreen") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    DeleteAllView()
//}
