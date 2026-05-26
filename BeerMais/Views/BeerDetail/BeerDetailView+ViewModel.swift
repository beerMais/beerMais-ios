//
//  ViewModel.swift
//  BeerMais
//
//  Created by José Neves on 18/10/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import Combine

extension BeerDetailView {
    
    final class ViewModel: ObservableObject {
        @Published var brand: String
        @Published var price: String
        @Published var size: String
        @Published var sizeSelection: Segment
        @Published var sizeType: String
        
        private var cancellables = Set<AnyCancellable>()
        private var isUpdatingSizeSelection = false
        private var isUpdatingSize = false

        var onFinish: (() -> Void)?

        private let selectedBeer: Beer?
        private let worker = BeerWorker()
        
        init(selectedBeer: Beer?) {
            self.selectedBeer = selectedBeer
            
            self.brand = selectedBeer?.brand ?? ""
            self.price = selectedBeer?.value.formatted(.number.precision(.fractionLength(2))) ?? ""

            self.size = selectedBeer?.amount.asString ?? ""
            self.sizeType = selectedBeer?.amount == 1000 ? "L" : "ml"
            
            switch selectedBeer?.amount {
            case Segment.first.amount:
                self.sizeSelection = .first
            case Segment.second.amount:
                self.sizeSelection = .second
            case Segment.third.amount:
                self.sizeSelection = .third
            case Segment.fourth.amount:
                self.sizeSelection = .fourth
            default:
                self.sizeSelection = .first
            }
            
            $sizeSelection.sink { [weak self] value in
                guard let self, !isUpdatingSizeSelection else { return }
                       
                guard value.name != self.size else { return }

                isUpdatingSize = true
                defer { isUpdatingSize = false }
                
                switch value.name {
                case Segment.first.name:
                    sizeType = "ml"
                    size = Segment.first.name
                case Segment.second.name:
                    sizeType = "ml"
                    size = Segment.second.name
                case Segment.third.name:
                    sizeType = "ml"
                    size = Segment.third.name
                case Segment.fourth.name:
                    sizeType = "L"
                    size = Segment.fourth.name
                default: break
                }
            }.store(in: &cancellables)
            
            $size.sink { [weak self] value in
                guard let self, !isUpdatingSize else { return }
                        
                guard value != self.sizeSelection.name else { return }
                
                isUpdatingSizeSelection = true
                defer { isUpdatingSizeSelection = false }
                
                switch value {
                case Segment.first.name:
                    sizeSelection = .first
                case Segment.second.name:
                    sizeSelection = .second
                case Segment.third.name:
                    sizeSelection = .third
                case Segment.fourth.name:
                    sizeSelection = .fourth
                default: break
                }
            }.store(in: &cancellables)
        }
        
        func createOrSave() {
            let data = BeerData(
                brand: brand,
                value: price.parseStringValueToFloat,
                amount: normalizedAmount
            )
            if let selectedBeer {
                worker.edit(beer: selectedBeer, data: data)
            } else {
                worker.createBeer(data: data)
            }
            
            onFinish?()
        }
        
        func delete() {
            guard let selectedBeer else { return }
            worker.delete(beer: selectedBeer)
            
            onFinish?()
        }
        
        // MARK: Private

        private var normalizedAmount: Int16 {
            if sizeSelection == .fourth {
                return 1000
            }

            return size.onlyNumbers.asInt16.orZero
        }
    }
}
