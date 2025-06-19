//
//  AlertPresenterTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 29/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import Testing

import BasicsKit

struct AlertPresenterTests {
    
    var sut: AlertPresenter!
    var viewControllerSpy: AlertViewControllerSpy!
    
    init() throws {
        viewControllerSpy = .init()
        sut = .init(view: viewControllerSpy)
    }
    
    @Test
    mutating func testSetupData() {
        let expectedTitle = String.random()
        let expectedDescription = String.random()
        let expectedNegativeActionTitle = String.random()
        let expectedPositiveActionTitle = String.random()
        
        let details = AlertInteractor.AlertDetails(
            title: expectedTitle,
            description: expectedDescription,
            negativeActionTitle: expectedNegativeActionTitle,
            positiveActionTitle: expectedPositiveActionTitle
        )
        
        sut.setupData(with: details)
        
        #expect(viewControllerSpy.setTitleCalls.count == 1)
        #expect(viewControllerSpy.setTitleCalls.first?.title == expectedTitle)
        
        #expect(viewControllerSpy.setDescriptionCalls.count == 1)
        #expect(viewControllerSpy.setDescriptionCalls.first?.description == expectedDescription)
        
        #expect(viewControllerSpy.setNegativeButtonTitleCalls.count == 1)
        #expect(viewControllerSpy.setNegativeButtonTitleCalls.first?.title == expectedNegativeActionTitle)
        
        #expect(viewControllerSpy.setPositiveButtonTitleCalls.count == 1)
        #expect(viewControllerSpy.setPositiveButtonTitleCalls.first?.title == expectedPositiveActionTitle)
    }
    
    @Test
    mutating func testClose() {
        sut.close()
        
        #expect(viewControllerSpy.closeCalls.count == 1)
    }
}
