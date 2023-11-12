//
//  DonateTableViewCellPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 16/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import Foundation
import StoreKit

protocol DonateTableViewCellDelegate {
    func reloadAvailableDonates()
}

class DonateTableViewCellPresenter: NSObject {
    
    typealias PurchaseProductResult = Result<Bool, Error>
    
    var availableDonates: [DonateProduct] = []
    var delegate: DonateTableViewCellDelegate?
    
    private let successFeedbackView = SuccessFeedbackView()

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
        
        purchaseProduct(product: donateProduct.product) { [weak self] result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
            
            self?.productPurchaseCallback = nil
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

        productPurchaseCallback = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}


// MARK: - SKProductsRequestDelegate

extension DonateTableViewCellPresenter: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(products)
        clearRequestAndHandler()
    }
}

// MARK: - SKPaymentTransactionObserver

extension DonateTableViewCellPresenter: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch (transaction.transactionState) {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                productPurchaseCallback?(.success(true))
                
                successFeedbackView.show()
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
