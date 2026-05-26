//
//  BeerDetailPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation
import BasicsKit

protocol BeerDetailPresenterProtocol {
    func brandValueChanged(value: String?)
    func priceValueChanged(value: String?)
    func amountValueChanged(value: String?)
    func amountSegmentChanged(index: Int)
    func deleteBeer()
    func editBeer()
    func createBeer()
}

final class BeerDetailPresenter: BeerDetailPresenterProtocol {
    
    // MARK: - Private Properties

    private var beer: Beer?
    private let amountValues: [Int: String] = [
        0: Segment.first.amount.asString,
        1: Segment.second.amount.asString,
        2: Segment.third.amount.asString,
        3: Segment.fourth.amount.asString
    ]
    
    private var beerBrand: String = ""
    private var beerAmount: Int16 = 0
    private var beerValue: Float = 0
    
    // MARK: - Injected Properties
    
    let beerWorker: BeerWorkerProtocol
 
    init(
        beerWorker: BeerWorkerProtocol
    ) {
        self.beerWorker = beerWorker
    }
    
    convenience init(
        beer: Beer?,
        beerWorker: BeerWorkerProtocol
    ) {
        self.init(beerWorker: beerWorker)
        
        if let currentBeer = beer {
            self.beer = currentBeer
            setupData()
        }
    }
    
    func setupData() {
        guard let beer = beer else { return }
        beerBrand = beer.brand ?? ""
        beerValue = beer.value
        beerAmount = beer.amount
    }
    
    func brandValueChanged(value: String?) {
        beerBrand = value.orEmpty.trimmingCharacters(in: .whitespaces)
    }
    
    func priceValueChanged(value: String?) {
        beerValue = value?.parseStringValueToFloat ?? 0
    }
    
    func amountValueChanged(value: String?) {
        if let amount = value?.asInt16 {
            beerAmount = amount
        }
    }
    
    func amountSegmentChanged(index: Int) {
        if index > amountValues.count {
            return
        }
        
        guard let amountValue = amountValues[index] else { return }
        
        beerAmount = amountValue.asInt16.orZero
    }
    
    func deleteBeer() {
        guard let beer = beer else { return }
        
        beerWorker.delete(beer: beer)
    }
    
    func editBeer() {
        guard let beer = beer else { return }
        
        if !validateBeerAndGetResult() {
            return
        }
        
        beerWorker.edit(beer: beer, data: currentBeerData())
    }
    
    func createBeer() {
        if !validateBeerAndGetResult() {
            return
        }
        
        beerWorker.createBeer(data: currentBeerData())
    }
    
    private func validateBeerAndGetResult() -> Bool {
        let isValidAmount = beerAmount > 0
        let isValidBrand = beerBrand.count > 0
        let isValidValue = beerValue > 0
        
        return isValidAmount && isValidBrand && isValidValue
    }
    
    private func currentBeerData() -> BeerData {
        BeerData(
            brand: beerBrand,
            value: beerValue,
            amount: beerAmount
        )
    }
}
