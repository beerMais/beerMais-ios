//
//  DonateTableViewCellPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 16/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import Foundation
import StoreKit

enum DonateType: Int {
    case small
    case medium
    case large
    
    var productId: String {
        var debugString = ""
        
        #if DEBUG
            debugString = "_debug"
        #endif
        
        switch self {
        case .small: return "small\(debugString)"
        case .medium: return "medium\(debugString)"
        case .large: return "large\(debugString)"
        }
    }
    
    static func getByProductId(_ productId: String) -> DonateType? {
        var debugString = ""
        
        #if DEBUG
            debugString = "_debug"
        #endif
        
        switch productId {
        case "small\(debugString)": return .small
        case "medium\(debugString)": return .medium
        case "large\(debugString)": return .large
        default: return nil
        }
    }
}

protocol DonateTableViewCellDelegate {
    func reloadAvailableDonates()
}

class DonateTableViewCellPresenter: NSObject {
    var availableDonates: [DonateType] = []
    var delegate: DonateTableViewCellDelegate?

    private let productIdentifiers: Set<String> = {
        return [DonateType.small.productId,
                DonateType.medium.productId,
                DonateType.large.productId]
    }()
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ((_ products: [SKProduct]?) -> Void)?
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        
        refreshAvailableDonates { [weak self] products in
            
            guard let products else { return }
            
            for product in products.sorted(by: { $0.price.doubleValue < $1.price.doubleValue }) {
                if let donateType = DonateType.getByProductId(product.productIdentifier) {
                    self?.availableDonates.append(donateType)
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
    
    func getDonateTypeByRow(_ row: Int) -> DonateType? {
        if row >= availableDonates.count {
            return nil
        }
        
        return availableDonates[row]
    }
    
    func didSelectDonateTypeByRow(_ row: Int) {
        guard let donateType = getDonateTypeByRow(row) else {
            return
        }
        
        print(donateType)
    }

    func refreshAvailableDonates(_ completionHandler: @escaping (_ products: [SKProduct]?) -> Void) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        
        guard let productsRequest = productsRequest else { return }
        productsRequest.delegate = self
        productsRequest.start()
    }

    private func clearRequestAndHandler() {
      productsRequest = nil
      productsRequestCompletionHandler = nil
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
            case .purchased:
            //          complete(transaction: transaction)
              break
            case .failed:
            //          fail(transaction: transaction)
              break
            case .restored:
            //          restore(transaction: transaction)
              break
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
