//
//  Donate.swift
//  BeerMais
//
//  Created by José Neves on 11/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import StoreKit

struct DonateProduct {
    
    let type: DonateType
    let name: String
    let price: Float
    let priceFormatted: String?
    let product: SKProduct
    
    init?(product: SKProduct) {
        
        guard let type = DonateType.getByProductId(product.productIdentifier) else { return nil }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR@currency=BRL")
        priceFormatted = numberFormatter.string(from: product.price)
        
        self.type = type
        self.name = product.localizedTitle
        self.price = product.price.floatValue
        self.product = product
    }
}

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
