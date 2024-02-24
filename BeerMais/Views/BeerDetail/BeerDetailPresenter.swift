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
        0: "269",
        1: "350",
        2: "473",
        3: "1000"
    ]
    
    private var beerBrand: String = ""
    private var beerAmount: Int16 = 0
    private var beerValue: Float = 0
    
    // MARK: - Injected Properties
    
    let view: BeerDetailViewProtocol
    let beerWorker: BeerWorkerProtocol
 
    init(
        view: BeerDetailViewProtocol,
        beerWorker: BeerWorkerProtocol
    ) {
        self.view = view
        self.beerWorker = beerWorker
    }
    
    convenience init(
        view: BeerDetailViewProtocol,
        beer: Beer?,
        beerWorker: BeerWorkerProtocol
    ) {
        self.init(view: view, beerWorker: beerWorker)
        
        if let currentBeer = beer {
            self.beer = currentBeer
            setupData()
            
            view.isEditMode(true)
        } else {
            view.isEditMode(false)
        }
    }
    
    func setupData() {
        guard let beer = beer else { return }
        beerBrand = beer.brand ?? ""
        beerValue = beer.value
        beerAmount = beer.amount
        
        view.setBrand(with: beerBrand)
        view.setPrice(with: beerValue.formatValueToShow)
        view.setSize(with: beerAmount.toString)
        parseAmountToFillSegment(beerAmount.toString)
    }
    
    func brandValueChanged(value: String?) {
        beerBrand = value.orEmpty.trimmingCharacters(in: .whitespaces)
    }
    
    func priceValueChanged(value: String?) {
        beerValue = value?.parseStringValueToFloat ?? 0
        
        view.setPrice(with: beerValue.formatValueToShow)
    }
    
    func amountValueChanged(value: String?) {
        parseAmountToFillSegment(value ?? "")
        
        if let amount = value?.toInt16 {
            beerAmount = amount
        }
    }
    
    func amountSegmentChanged(index: Int) {
        if index > amountValues.count {
            return
        }
        
        guard let amountValue = amountValues[index] else { return }
        
        beerAmount = amountValue.toInt16
        
        view.setSize(with: amountValue)
        
    }
    
    func deleteBeer() {
        guard let beer = beer else { return }
        
        beerWorker.delete(beer: beer)
        
        view.deleteSucess()
    }
    
    func editBeer() {
        guard let beer = beer else { return }
        
        if !validateBeerAndGetResult() {
            return
        }
        
        beerWorker.edit(beer: beer, data: beerDataDict())
        
        view.editSucess()
    }
    
    func createBeer() {
        if !validateBeerAndGetResult() {
            return
        }
        
        beerWorker.createBeer(data: beerDataDict())
        
        view.createSucess()
    }
    
    private func parseAmountToFillSegment(_ amountString: String) {
        let amountValue = amountValues.filter {
            $0.value == amountString
        }
        
        if amountValue.count > 0 {
            view.setSegmentIndex(amountValue.first?.key ?? -1)
        } else {
            view.setSegmentIndex(-1)
        }
    }
    
    private func validateBeerAndGetResult() -> Bool {
        
        let isValidAmount = beerAmount > 0
        let isValidBrand = beerBrand.count > 0
        let isValidValue = beerValue > 0
        
        view.setIsValidAmount(isValidAmount)
        view.setIsValidBrand(isValidBrand)
        view.setIsValidValue(isValidValue)
        
        return isValidAmount && isValidBrand && isValidValue
    }
    
    private func beerDataDict() -> [String: Any] {
        var data = [String: Any]()
        data["amount"] = beerAmount
        data["brand"] = beerBrand
        data["value"] = beerValue
        
        data["type"] = Int16(beerAmount >= 1000 ? 2 : 1)
        
        return data
    }
}
