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
    @StateObject private var viewModel: ViewModel

    init(worker: BeerWorkerProtocol) {
        _viewModel = StateObject(wrappedValue: ViewModel(worker: worker))
    }
    
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
                        if viewModel.deleteAllBeers() {
                            dismiss()
                        }
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
            .alert("beerOperationFailed", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
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

extension DeleteAllView {
    final class ViewModel: ObservableObject {
        @Published var errorMessage: String?
        private let worker: BeerWorkerProtocol

        init(worker: BeerWorkerProtocol) {
            self.worker = worker
        }

        func deleteAllBeers() -> Bool {
            errorMessage = nil
            let success = worker.deleteAllBeers()
            if !success { errorMessage = "beerDeleteFailed".localized }
            return success
        }
    }
}

//#Preview {
//    DeleteAllView()
//}
