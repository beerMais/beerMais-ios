//
//  DonateView+ViewModel.swift
//  BeerMais
//
//  Created by José Neves on 22/06/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import Combine
import StoreKit

extension DonateView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var donates = [DonateProduct]()
        
        private var updatesListener: Task<Void, Never>?
        private let productIDs: Set<String> = {
            [
                DonateType.small.productId,
                DonateType.medium.productId,
                DonateType.large.productId
            ]
        }()
        
        init() {
            loadProducts()
            startListeningForTransactions()
        }
        
        deinit {
            updatesListener?.cancel()
        }
        
        func buyProduct(_ donateProduct: DonateProduct) async -> DonationOutcome {
            do {
                guard let result = try await donateProduct.product?.purchase() else {
                    return .failed
                }
                switch result {
                case let .success(.verified(transaction)):
                    await transaction.finish()
                    return .success
                case .success(.unverified):
                    return .failed
                case .pending:
                    return .pending
                case .userCancelled:
                    return .cancelled
                @unknown default:
                    return .failed
                }
            } catch {
                return .failed
            }
        }

        // MARK: - Private
        
        private func loadProducts() {
            Task {
                do {
                    let donates = try await Product.products(for: productIDs)
                        .sorted(by: { $0.price < $1.price })
                        .compactMap {
                            DonateProduct(product: $0)
                        }
                    await MainActor.run {
                        self.donates = donates
                    }
                } catch {
                    print("Failed to fetch products!")
                }
            }
        }
        
        private func startListeningForTransactions() {
            updatesListener = Task.detached(priority: .background) {
                for await update in Transaction.updates {
                    do {
                        let verification = update
                        switch verification {
                        case .verified(let transaction):
                            await transaction.finish()
                        case .unverified(_, let error):
                            print("Unverified transaction. Error: \(String(describing: error))")
                        }
                    }
                }
            }
        }
    }
}
