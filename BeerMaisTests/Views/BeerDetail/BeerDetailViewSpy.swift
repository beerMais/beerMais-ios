//
//  BeerDetailViewSpy.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class BeerDetailViewSpy: BeerDetailViewProtocol {
    
    // MARK: - Calls
    
    var setBrandCalls: [SetBrandCall] = []
    
    var setPriceCalls: [SetPriceCall] = []
    
    var setSizeCalls: [SetSizeCall] = []
    
    var setSegmentIndexCalls: [SetSegmentIndexCall] = []
    
    var isEditModeCalls: [IsEditModeCall] = []
    
    var setIsValidAmountCalls: [SetIsValidAmountCall] = []
    
    var setIsValidBrandCalls: [SetIsValidBrandCall] = []
    
    var setIsValidValueCalls: [SetIsValidValueCall] = []
    
    var deleteSucessCalls: [DeleteSucessCall] = []
    
    var editSucessCalls: [EditSucessCall] = []
    
    var createSucessCalls: [CreateSucessCall] = []
    
    // MARK: - BeerDetailViewProtocol
    
    func setBrand(with brand: String) {
        setBrandCalls.append(.init(
            brand: brand
        ))
    }
    
    func setPrice(with price: String) {
        setPriceCalls.append(.init(
            price: price
        ))
    }
    
    func setSize(with size: String) {
        setSizeCalls.append(.init(
            size: size
        ))
    }
    
    func setSegmentIndex(_ index: Int) {
        setSegmentIndexCalls.append(.init(
            index: index
        ))
    }
    
    func isEditMode(_ isEditMode: Bool) {
        isEditModeCalls.append(.init(
            isEditMode: isEditMode
        ))
    }
    
    func setIsValidAmount(_ isValidAmount: Bool) {
        setIsValidAmountCalls.append(.init(
            isValidAmount: isValidAmount
        ))
    }
    
    func setIsValidBrand(_ isValidBrand: Bool) {
        setIsValidBrandCalls.append(.init(
            isValidBrand: isValidBrand
        ))
    }
    
    func setIsValidValue(_ isValidValue: Bool) {
        setIsValidValueCalls.append(.init(
            isValidValue: isValidValue
        ))
    }
    
    func deleteSucess() {
        deleteSucessCalls.append(.init())
    }
    
    func editSucess() {
        editSucessCalls.append(.init())
    }
    
    func createSucess() {
        createSucessCalls.append(.init())
    }
    
    // MARK: - Call structs
    
    struct SetBrandCall {
        let brand: String
    }
    
    struct SetPriceCall {
        let price: String
    }
    
    struct SetSizeCall {
        let size: String
    }
    
    struct SetSegmentIndexCall {
        let index: Int
    }
    
    struct IsEditModeCall {
        let isEditMode: Bool
    }
    
    struct SetIsValidAmountCall {
        let isValidAmount: Bool
    }

    struct SetIsValidBrandCall {
        let isValidBrand: Bool
    }

    struct SetIsValidValueCall {
        let isValidValue: Bool
    }
    
    struct DeleteSucessCall {}

    struct EditSucessCall {}

    struct CreateSucessCall {}

}
