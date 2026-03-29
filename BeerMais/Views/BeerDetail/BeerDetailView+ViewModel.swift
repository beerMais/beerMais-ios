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
            self.price = selectedBeer?.value.asString ?? ""
            self.size = selectedBeer?.amount.asString ?? ""
            self.sizeType = "ml"
            
            switch selectedBeer?.amount.asString {
            case Segment.first.name:
                self.sizeSelection = .first
            case Segment.second.name:
                self.sizeSelection = .second
            case Segment.third.name:
                self.sizeSelection = .third
            case Segment.fourth.name:
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
                    size = Segment.first.name
                case Segment.second.name:
                    size = Segment.second.name
                case Segment.third.name:
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
            let data: [String : Any] = [
                "amount": size.onlyNumbers.asInt16.orZero,
                "brand": brand,
                "value": price.parseStringValueToFloat,
                "type": size.asInt16.orZero < 1000 ? 1 : 2
            ]
            if let selectedBeer {
                worker.edit(beer: selectedBeer, data: data)
            } else {
                worker.createBeer(data: data)
            }
            
            cleanUp()
            onFinish?()
        }
        
        func delete() {
            guard let selectedBeer else { return }
            worker.delete(beer: selectedBeer)
            
            cleanUp()
            onFinish?()
        }
        
        // MARK: Private
        
        private func cleanUp() {
            self.brand = ""
            self.price = ""
            self.size = ""
            self.sizeSelection = .first
        }
    }
}
