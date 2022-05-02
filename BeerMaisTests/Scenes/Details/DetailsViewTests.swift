//
//  DetailsViewTests.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import XCTest

final class DetailsViewTests: XCTestCase {
    
    var sut: DetailsInteractor!
    var spy: DetailsViewControllerSpy!
    
    override func setUp() {
        spy = DetailsViewControllerSpy()
        sut = DetailsTestsFactory.build(with: spy)
    }
    
    override func tearDown() {
        sut =  nil
        spy =  nil
    }
    
    func testSetupInitialData() {
        // Given
        
        // When
        
        // Then
        XCTAssertEqual(spy.setupDataCalls, 0)
    }
    
    func testSetupInitialDataWithBeer() {
        // Given
        let beer = Beer()
        
        // When
        sut = DetailsTestsFactory.build(with: spy, beer: beer)
        
        // Then
        XCTAssertEqual(spy.setupDataCalls, 1)
    }
    
}
