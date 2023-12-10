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
        
        XCTAssertEqual(viewControllerSpy.setTitleCalls.count, 1)
        XCTAssertEqual(viewControllerSpy.setTitleCalls.first?.title, expectedTitle)
        
        XCTAssertEqual(viewControllerSpy.setDescriptionCalls.count, 1)
        XCTAssertEqual(viewControllerSpy.setDescriptionCalls.first?.description, expectedDescription)
        
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleCalls.count, 1)
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleCalls.first?.title, expectedNegativeActionTitle)
        
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleCalls.count, 1)
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleCalls.first?.title, expectedPositiveActionTitle)
    }
    
    func testClose() {
        
        sut.close()
        
        XCTAssertEqual(viewControllerSpy.closeCalls.count, 1)
    }
}
