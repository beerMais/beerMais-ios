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
        XCTAssertEqual(spy.isEditModeCalls.first?.isEditMode ?? true, false)
        XCTAssertEqual(spy.setBrandCalls.count, 0)
        XCTAssertEqual(spy.setPriceCalls.count, 0)
        XCTAssertEqual(spy.setSizeCalls.count, 0)
        XCTAssertEqual(spy.setSegmentIndexCalls.count, 0)
        XCTAssertEqual(spy.isEditModeCalls.count, 1)
    }
    
    func testSetupWithBeer() {
        // Given
        let beer = Beer.mock()
        beer.amount = 350
        beer.brand = "test brand"
        beer.value = 2.59
        beer.type = 1
        
        // When
        sut = BeerDetailTestsFactory.build(with: spy, beer: beer)
        
        // Then
        XCTAssertEqual(spy.isEditModeCalls.last?.isEditMode ?? false, true)
        XCTAssertEqual(spy.setBrandCalls.count, 1)
        XCTAssertEqual(spy.setBrandCalls.first?.brand, "test brand")
        XCTAssertEqual(spy.setPriceCalls.count, 1)
        XCTAssertEqual(spy.setPriceCalls.first?.price, "R$ 2,59")
        XCTAssertEqual(spy.setSizeCalls.count, 1)
        XCTAssertEqual(spy.setSizeCalls.first?.size, "350")
    }
}
