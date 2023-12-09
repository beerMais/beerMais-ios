//
//  BeerWorkerStub.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation

final class BeerWorkerStub: BeerWorkerProtocol {
    
    init() {
        
    }
    
    var createBeerData: [String : Any]?
    var createBeerReturn: Beer?
    @discardableResult func createBeer(data: [String : Any]) -> Beer? {
        createBeerData = data
        
        return createBeerReturn
    }
    
    var getBeersReturn: [Beer] = []
    func getBeers() -> [Beer] {
        getBeersReturn
    }
    
    var editBeer: Beer? = nil
    var editData: [String : Any]?
    func edit(beer: Beer, data: [String : Any]) {
        editBeer = beer
        editData = data
    }
    
    func deleteAllBeers() {
    }
    
    var deleteBeer: Beer?
    func delete(beer: Beer) {
        deleteBeer = beer
    }
    
    var orderBeersBeers: [Beer] = []
    var orderBeersReturn: [Beer] = []
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        orderBeersBeers = beers
        
        return orderBeersReturn
    }
    
    
    var getValuePerMLbeer: Beer?
    var getValuePerMLReturn: Float = .random
    func getValuePerML(beer: Beer) -> Float {
        getValuePerMLbeer = beer
        
        return getValuePerMLReturn
    }
    
    var calcEconomyBetweenBeersBeer1: Beer?
    var calcEconomyBetweenBeersBeer2: Beer?
    var calcEconomyBetweenBeersReturn: Float = .random
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float {
        calcEconomyBetweenBeersBeer1 = beer1
        calcEconomyBetweenBeersBeer2 = beer2
        
        return calcEconomyBetweenBeersReturn
    }
    
    var formatBeerValueToShowValue: Float?
    var formatBeerValueToShowReturn: String = .random
    func formatBeerValueToShow(value: Float) -> String {
        formatBeerValueToShowValue = value
        
        return formatBeerValueToShowReturn
    }
    
    var calculateMostValuableBeerBeers: [Beer] = []
    var calculateMostValuableBeerReturn: Beer? = nil
    func calculateMostValuableBeer(beers: [Beer]) -> Beer? {
        calculateMostValuableBeerBeers = beers
        
        return calculateMostValuableBeerReturn
    }
}
