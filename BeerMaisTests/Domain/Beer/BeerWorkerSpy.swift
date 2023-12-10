//
//  BeerWorkerSpy.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation

final class BeerWorkerSpy: BeerWorkerProtocol {
    
    // MARK: - Calls
    
    var createBeerCalls: [CreateBeerCall] = []
    var createBeerReturn: Beer? = nil
    
    var getBeersCalls: [GetBeersCall] = []
    var getBeersReturn: [Beer] = []
    
    var editCalls: [EditCall] = []
    
    var deleteAllCalls: [DeleteAllCall] = []
    
    var deleteCalls: [DeleteCall] = []
    
    var orderBeersCalls: [OrderBeersCall] = []
    var orderBeersReturn: [Beer] = []
    
    var getValuePerMLCalls: [GetValuePerMLCall] = []
    var getValuePerMLReturn: Float = .random
    
    var calcEconomyBetweenBeersCalls: [CalcEconomyBetweenBeersCall] = []
    var calcEconomyBetweenBeersReturn: Float = .random
    
    var formatBeerValueToShowCalls: [FormatBeerValueToShowCall] = []
    var formatBeerValueToShowReturn: String = .random
    
    var calculateMostValuableBeerCalls: [CalculateMostValuableBeerCall] = []
    var calculateMostValuableBeerReturn: Beer? = nil
    
    // MARK: - BeerWorkerProtocol
    
    @discardableResult func createBeer(data: [String : Any]) -> Beer? {
        createBeerCalls.append(.init(
            data: data,
            returnedValue: createBeerReturn
        ))
        
        return createBeerReturn
    }
    
    func getBeers() -> [Beer] {
        getBeersCalls.append(.init(
            returnedValue: getBeersReturn
        ))
        
        return getBeersReturn
    }
    
    func edit(beer: Beer, data: [String : Any]) {
        editCalls.append(.init(
            beer: beer,
            data: data
        ))
    }
    
    func deleteAllBeers() {
        deleteAllCalls.append(.init())
    }
    
    func delete(beer: Beer) {
        deleteCalls.append(.init(
            beer: beer
        ))
    }
    
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        orderBeersCalls.append(.init(
            beers: beers,
            returnedValue: orderBeersReturn
        ))
        
        return orderBeersReturn
    }
    
    func getValuePerML(beer: Beer) -> Float {
        getValuePerMLCalls.append(.init(
            beer: beer,
            returnedValue: getValuePerMLReturn
        ))
        
        return getValuePerMLReturn
    }
    
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float {
        calcEconomyBetweenBeersCalls.append(.init(
            beer1: beer1,
            beer2: beer2,
            returnedValue: calcEconomyBetweenBeersReturn
        ))
        
        return calcEconomyBetweenBeersReturn
    }
    
    func formatBeerValueToShow(value: Float) -> String {
        formatBeerValueToShowCalls.append(.init(
            value: value,
            returnedValue: formatBeerValueToShowReturn
        ))
        
        return formatBeerValueToShowReturn
    }
    
    func calculateMostValuableBeer(beers: [Beer]) -> Beer? {
        calculateMostValuableBeerCalls.append(.init(
            beers: beers,
            returnedValue: calculateMostValuableBeerReturn
        ))
        
        return calculateMostValuableBeerReturn
    }
    
    // MARK: - Call structs
    
    struct CreateBeerCall {
        let data: [String : Any]
        let returnedValue: Beer?
    }
    
    struct GetBeersCall {
        let returnedValue: [Beer]
    }
    
    struct EditCall {
        let beer: Beer
        let data: [String : Any]
    }
    
    struct DeleteAllCall {}
    
    struct DeleteCall {
        let beer: Beer
    }
    
    struct OrderBeersCall {
        let beers: [Beer]
        let returnedValue: [Beer]
    }
    
    struct GetValuePerMLCall {
        let beer: Beer
        let returnedValue: Float
    }
    
    struct CalcEconomyBetweenBeersCall {
        let beer1: Beer
        let beer2: Beer
        let returnedValue: Float
    }
    
    struct FormatBeerValueToShowCall {
        let value: Float
        let returnedValue: String
    }
    
    struct CalculateMostValuableBeerCall {
        let beers: [Beer]
        let returnedValue: Beer?
    }
}
