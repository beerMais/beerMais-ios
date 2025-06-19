//
//  DetailsTests.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation
import Testing

struct DetailsTests {
    
    var sut: DetailsInteractor!
    var spy: DetailsViewControllerSpy!
    
    init() throws {
        spy = DetailsViewControllerSpy()
        sut = DetailsTestsFactory.build(with: spy)
    }
    
    @Test
    func testSetupInitialData() {
        #expect(spy.setupDataCalls.count == 0)
    }
    
    @Test
    mutating func testSetupInitialDataWithBeer() {
        let beer = Beer()
        
        sut = DetailsTestsFactory.build(with: spy, beer: beer)
        
        #expect(spy.setupDataCalls.count == 1)
    }
    
}
