//
//  BeerDetailTests.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import XCTest

final class BeerDetailTests: XCTestCase {
    
    var sut: BeerDetailPresenter!
    var spy: BeerDetailViewSpy!
    
    override func setUp() {
        spy = BeerDetailViewSpy()
        sut = BeerDetailTestsFactory.build(with: spy)
    }
    
    override func tearDown() {
        sut = nil
        spy = nil
    }
    
    func testSetupWithoutBeer() {
        // Given
        
        // When
        
        // Then
        XCTAssertFalse(spy.isEditModeValue ?? true)
        XCTAssertEqual(spy.setBrandCalls, 0)
        XCTAssertEqual(spy.setPriceCalls, 0)
        XCTAssertEqual(spy.setSizeCalls, 0)
        XCTAssertEqual(spy.setSegmentIndexCalls, 0)
        XCTAssertEqual(spy.isEditModeCalls, 1)
    }
    
    func testSetupWithBeer() {
        // Given
        var beerData = [String: Any]()
        beerData["amount"] = Int16(350)
        beerData["brand"] = "test brand"
        beerData["value"] = 2.59
        beerData["type"] = Int16(1)
        
        let beer = BeerP().create(data: beerData)
        
        // When
        sut = BeerDetailTestsFactory.build(with: spy, beer: beer)
        
        // Then
        XCTAssertTrue(spy.isEditModeValue ?? false)
        XCTAssertEqual(spy.setBrandCalls, 1)
        XCTAssertEqual(spy.setBrandBrand, "test brand")
        XCTAssertEqual(spy.setPriceCalls, 1)
        XCTAssertEqual(spy.setPricePrice, "R$ 1,00")
        XCTAssertEqual(spy.setSizeCalls, 1)
        XCTAssertEqual(spy.setSizeSize, "269 ml")
    }
}
