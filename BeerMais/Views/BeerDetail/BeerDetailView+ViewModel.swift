//
//  ViewModel.swift
//  BeerMais
//
//  Created by José Neves on 18/10/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

extension BeerDetailView {
    
    final class ViewModel: ObservableObject {
        @Published var brand: String
        // Decimal amount used by validation and persistence.
        @Published var price: String
        @Published var size: String
        @Published var errorMessage: String?

        // The editor treats digits as cents; keep formatting string-based to avoid rounding.
        var priceInput: String {
            get { price.isEmpty ? "0,00" : price }
            set {
                if let formatted = BeerDisplay.centsInput(newValue) { price = formatted }
            }
        }

        // Millilitres are the source of truth; presets are shortcuts for this field.
        let sizeType = "ml"
        var sizeSelection: Segment? {
            get { Segment.allCases.first { String($0.amount) == size } }
            set {
                if let newValue { size = String(newValue.amount) }
            }
        }

        private var validatedPrice: Float? {
            guard price.range(of: #"^[0-9]+([.,][0-9]{1,2})?$"#, options: .regularExpression) != nil,
                  let value = Float(price.replacingOccurrences(of: ",", with: ".")),
                  value.isFinite, value > 0 else { return nil }
            return value
        }

        var pricePerLiter: Float? {
            guard let value = validatedPrice, let amount = Int16(size), amount > 0 else { return nil }
            let rate = value / Float(amount) * 1000
            return rate.isFinite ? rate : nil
        }

        var onFinish: (() -> Void)?
        private let selectedBeer: Beer?
        private let worker: BeerWorkerProtocol

        init(selectedBeer: Beer?, worker: BeerWorkerProtocol) {
            self.selectedBeer = selectedBeer
            self.worker = worker
            brand = selectedBeer?.brand ?? ""
            price = selectedBeer.map { BeerDisplay.decimal($0.value) } ?? "0,00"
            size = String(selectedBeer?.amount ?? Segment.first.amount)
        }

        func createOrSave() {
            let normalizedBrand = brand.trimmingCharacters(in: .whitespacesAndNewlines)

            errorMessage = nil
            guard !normalizedBrand.isEmpty else {
                errorMessage = "beerBrandRequired".localized
                return
            }
            guard let value = validatedPrice else {
                errorMessage = "beerPriceInvalid".localized
                return
            }
            guard let amount = Int16(size), amount > 0 else {
                errorMessage = "beerVolumeInvalid".localized
                return
            }

            let data = BeerData(
                brand: normalizedBrand,
                value: value,
                amount: amount
            )
            let didSave: Bool
            if let selectedBeer {
                didSave = worker.edit(beer: selectedBeer, data: data)
            } else {
                didSave = worker.createBeer(data: data) != nil
            }
            
            if didSave {
                onFinish?()
            } else {
                errorMessage = "beerSaveFailed".localized
            }
        }
        
        func delete() {
            guard let selectedBeer else { return }
            errorMessage = nil
            guard worker.delete(beer: selectedBeer) else {
                errorMessage = "beerDeleteFailed".localized
                return
            }
            
            onFinish?()
        }
        
    }
}
