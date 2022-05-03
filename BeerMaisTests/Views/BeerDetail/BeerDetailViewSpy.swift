//
//  BeerDetailViewSpy.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class BeerDetailViewSpy: BeerDetailViewProtocol {
    
    var setBrandCalls = 0
    var setBrandBrand: String?
    func setBrand(with brand: String) {
        setBrandCalls += 1
        setBrandBrand = brand
    }
    
    var setPriceCalls = 0
    var setPricePrice: String?
    func setPrice(with price: String) {
        setPriceCalls += 1
        setPricePrice = price
    }
    
    var setSizeCalls = 0
    var setSizeSize: String?
    func setSize(with size: String) {
        setSizeCalls += 1
        setSizeSize = size
    }
    
    var setSegmentIndexCalls = 0
    func setSegmentIndex(_ index: Int) {
        setSegmentIndexCalls += 1
    }
    
    var isEditModeCalls = 0
    var isEditModeValue: Bool?
    func isEditMode(_ isEditMode: Bool) {
        isEditModeCalls += 1
        isEditModeValue = isEditMode
    }
    
    var setIsValidAmountCalls = 0
    func setIsValidAmount(_ isValidAmount: Bool) {
        setIsValidAmountCalls += 1
    }
    
    var setIsValidBrandCalls = 0
    func setIsValidBrand(_ isValidBrand: Bool) {
        setIsValidBrandCalls += 1
    }
    
    var setIsValidValueCalls = 0
    func setIsValidValue(_ isValidValue: Bool) {
        setIsValidValueCalls += 1
    }
    
    var deleteSucessCalls = 0
    func deleteSucess() {
        deleteSucessCalls += 1
    }
    
    var editSucessCalls = 0
    func editSucess() {
        editSucessCalls += 1
    }
    
    var createSucessCalls = 0
    func createSucess() {
        createSucessCalls += 1
    }

}
