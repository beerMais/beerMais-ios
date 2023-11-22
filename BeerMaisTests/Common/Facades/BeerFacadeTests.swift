//
//  BeerFacadeTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import CoreData
import Foundation
import XCTest

final class BeerFacadeTests: XCTestCase {
    
    var sut: BeerFacade!
    
    override func setUp() {
        sut = BeerFacade()
    }
    
    override func tearDown() {
        sut =  nil
    }
    
    func testOrderBeersWithEmptyList() {
        XCTAssertEqual(sut.orderBeers([]), [])
    }
    
    func testOrderBeersWithOneBeer() {
        let beer = Beer.mock()
        
        XCTAssertEqual(sut.orderBeers([beer]), [beer])
    }
    
    func testOrderBeersWithBeerList() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.orderBeers([beer, beer2]), [beer, beer2])
        XCTAssertEqual(sut.orderBeers([beer2, beer]), [beer, beer2])
    }
    
    func testGetValuePerML() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.getValuePerML(beer: beer), 0.01)
        XCTAssertEqual(sut.getValuePerML(beer: beer2), 0.011)
    }
    
    func testCalcEconomyBetweenBeers() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 15.0
        beer2.amount = 1000

        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer, beer2: beer2), 5)
        
        let beer3 = Beer.mock()
        beer3.value = 2.19
        beer3.amount = 350
        
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer3, beer2: beer), 3.742857)
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer, beer2: beer3), -3.742857)
        
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer3, beer2: beer2), 8.742857)
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer2, beer2: beer3), -8.742857)
    }
    
    func testFormatBeerValueToShow() {
        
        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        XCTAssertEqual(sut.formatBeerValueToShow(value: beer.value), "10,00")
        
        let beer2 = Beer.mock()
        beer2.value = 2.19
        beer2.amount = 350

        XCTAssertEqual(sut.formatBeerValueToShow(value: beer2.value), "2,19")
    }
    
    func testCalculateMostValuableBeer() {
        
        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.calculateMostValuableBeer(beers: [beer, beer2]), beer)
        XCTAssertEqual(sut.calculateMostValuableBeer(beers: [beer2, beer]), beer)
    }
}
