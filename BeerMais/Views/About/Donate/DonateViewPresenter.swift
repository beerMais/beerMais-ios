//
//  DonateTableViewCellPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 16/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import Foundation
import StoreKit

protocol DonateViewDelegate {
    func reloadAvailableDonates()
}

final class DonateViewPresenter: NSObject {
    
    typealias PurchaseProductResult = Result<Bool, Error>
    
    var availableDonates: [DonateProduct] = []
    var delegate: DonateViewDelegate?
    
#if !(DEBUG_APPCLIP || APPCLIP)
    private let successFeedbackView = SuccessFeedbackView()
    private let loadingView = LoadingView()
#endif

    private let productIdentifiers: Set<String> = {
        return [DonateType.small.productId,
                DonateType.medium.productId,
                DonateType.large.productId]
    }()
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ((_ products: [SKProduct]?) -> Void)?
    private var productPurchaseCallback: ((PurchaseProductResult) -> Void)?
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        
        refreshAvailableDonates { [weak self] products in
            
            guard let products else { return }
            
            for product in products.sorted(by: { $0.price.doubleValue < $1.price.doubleValue }) {
                
                if let donateProduct = DonateProduct(product: product) {
                    self?.availableDonates.append(donateProduct)
                }
            }
            
            DispatchQueue.main.async {
                self?.delegate?.reloadAvailableDonates()
            }
        }
    }
    
    func availableDonatesCount() -> Int {
        return availableDonates.count
    }
    
    func getDonateTypeByRow(_ row: Int) -> DonateProduct? {
        if row >= availableDonates.count {
            return nil
        }
        
        return availableDonates[row]
    }
    
    func didSelectDonateTypeByRow(_ row: Int) {
        guard let donateProduct = getDonateTypeByRow(row) else {
            return
        }
        
        AppP.amplitude.track(event: .init(
            eventType: "donate_tap",
            eventProperties: [
                "product": donateProduct.name
            ]
        ))
        
        purchaseProduct(product: donateProduct.product) { [weak self] _ in
            self?.productPurchaseCallback = nil
#if !(DEBUG_APPCLIP || APPCLIP)
            self?.loadingView.hide()
#endif
        }
    }

    func refreshAvailableDonates(_ completionHandler: @escaping (_ products: [SKProduct]?) -> Void) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    private func clearRequestAndHandler() {
      productsRequest = nil
      productsRequestCompletionHandler = nil
    }
    
    private func purchaseProduct(product: SKProduct, completion: @escaping (PurchaseProductResult) -> Void) {
        guard productPurchaseCallback == nil else {
            completion(.failure(PurchasesError.purchaseInProgress))
            return
        }
        
#if !(DEBUG_APPCLIP || APPCLIP)
        loadingView.show()
#endif

        productPurchaseCallback = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}


// MARK: - SKProductsRequestDelegate

extension DonateViewPresenter: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(products)
        clearRequestAndHandler()
    }
}

// MARK: - SKPaymentTransactionObserver

extension DonateViewPresenter: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            AppP.amplitude.track(event: .init(
                eventType: "donate_transaction",
                eventProperties: [
                    "transaction_state": transaction.transactionState.rawValue
                ]
            ))
            
            switch (transaction.transactionState) {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                productPurchaseCallback?(.success(true))
                
#if !(DEBUG_APPCLIP || APPCLIP)
                successFeedbackView.show()
#endif
            case .failed:
                productPurchaseCallback?(.failure(transaction.error ?? PurchasesError.unknown))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
              break
            case .purchasing:
              break
            @unknown default:
                break
            }
        }
    }
}

enum PurchasesError: Error {
    case purchaseInProgress
    case productNotFound
    case unknown
}
