//
//  AlertPresenterTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 29/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

import BasicsKit

final class AlertPresenterTests: XCTestCase {
    
    var sut: AlertPresenter!
    var viewControllerSpy: AlertViewControllerSpy!
    
    override func setUp() {
        viewControllerSpy = .init()
        sut = .init(view: viewControllerSpy)
    }
    
    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
    }
    
    func testSetupData() {
        
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
        
        XCTAssertEqual(viewControllerSpy.setTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setTitleTitle, expectedTitle)
        
        XCTAssertEqual(viewControllerSpy.setDescriptionCalls, 1)
        XCTAssertEqual(viewControllerSpy.setDescriptionDescription, expectedDescription)
        
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleTitle, expectedNegativeActionTitle)
        
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleTitle, expectedPositiveActionTitle)
    }
    
    func testClose() {
        
        sut.close()
        
        XCTAssertEqual(viewControllerSpy.closeCalls, 1)
    }
}
