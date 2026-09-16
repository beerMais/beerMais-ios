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
        @Published var price: String
        @Published var size: String
        @Published var errorMessage: String?

        // Millilitres are the source of truth; presets are shortcuts for this field.
        let sizeType = "ml"
        var sizeSelection: Segment? {
            get { Segment.allCases.first { String($0.amount) == size } }
            set {
                if let newValue { size = String(newValue.amount) }
            }
        }

        var onFinish: (() -> Void)?
        private let selectedBeer: Beer?
        private let worker: BeerWorkerProtocol

        init(selectedBeer: Beer?, worker: BeerWorkerProtocol) {
            self.selectedBeer = selectedBeer
            self.worker = worker
            brand = selectedBeer?.brand ?? ""
            price = selectedBeer.map { String(format: "%.2f", $0.value) } ?? ""
            size = String(selectedBeer?.amount ?? Segment.first.amount)
        }

        func createOrSave() {
            let normalizedBrand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
            let value = price.parseStringValueToFloat

            errorMessage = nil
            guard !normalizedBrand.isEmpty else {
                errorMessage = "beerBrandRequired".localized
                return
            }
            let validPrice = price.range(of: #"^[0-9]+([.,][0-9]{1,2})?$"#, options: .regularExpression) != nil
            guard validPrice, value.isFinite, value > 0 else {
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
