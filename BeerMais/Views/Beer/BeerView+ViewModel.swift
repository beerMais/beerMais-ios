//
//  BeerView+ViewModel.swift
//  BeerMais
//
//  Created by José Neves on 09/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import Combine
import StoreKit

extension BeerView {
    final class ViewModel: ObservableObject {
        @Published var beer: Beer? {
            didSet { beerUpdated() }
        }
        @Published var economy: Float? {
            didSet { economyUpdated() }
        }
        
        @Published var brand: String = ""
        @Published var amount: String = ""
        @Published var beerValue: String = ""
        @Published var beerEconomyValue: String = ""
        @Published var itemNumber: Int?
        
        var image: Image {
            let imageName = switch beer?.type {
            case 0: "icons8-beer-bottle-100"
            default: "icons8-beer-can-100"
            }
            
            return Image(imageName)
        }
        
        let isHighlighted: Bool
        
        private let index: Int?
        private let worker = BeerWorker()
        
        init(beer: Beer? = nil, index: Int? = nil, isHighlighted: Bool = false) {
            self.index = index
            self.isHighlighted = isHighlighted
            
            if let beer {
                self.beer = beer
            }
            
            if let index {
                self.itemNumber = index + 1
            }
            beerUpdated()
        }
        
        private func beerUpdated() {
            setBrand()
            setAmount()
            setValue()
            if !isHighlighted {
                setValuePerML()
            }
        }
        
        private func economyUpdated() {
            guard isHighlighted else { return }
            setEconomy()
        }
        
        private func setBrand() {
            self.brand = beer?.brand ?? "brand".localized
        }
        
        private func setAmount() {
            let amount = beer?.amount ?? 350
            
            let amountText: String
            if amount >= 1000 {
                var amountString = String(format: "%.2f", Float(amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".00", with: "")
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                    
                amountText = "\(amountString) L"
            } else {
                amountText = "\(amount)ml"
            }
            
            self.amount = amountText
        }
        
        private func setValue() {
            let valueString = worker.formatBeerValueToShow(value: beer?.value ?? 0)
            
            beerValue = "R$ \(valueString)"
        }
        
        private func setValuePerML() {
            var valuePerLiter: Float = 0
            if let beer = beer,
               beer.amount != 0 && beer.value != 0 {
                valuePerLiter = worker.getValuePerML(beer: beer) * 1000
            }
            
            beerEconomyValue = "R$ \(worker.formatBeerValueToShow(value: valuePerLiter))/L"
        }
        
        private func setEconomy() {
            guard let economy else { return }
            beerEconomyValue = "R$ \(worker.formatBeerValueToShow(value: economy))/L"
        }
    }
}
