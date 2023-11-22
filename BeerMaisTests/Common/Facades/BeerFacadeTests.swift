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
}
