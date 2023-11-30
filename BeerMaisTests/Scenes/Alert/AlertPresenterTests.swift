//
//  AlertPresenterTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 29/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

final class AlertPresenterTests: XCTest {
    
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
        let details = AlertInteractor.AlertDetails()
        
        sut.setupData(with: details)
        
        XCTAssertEqual(viewControllerSpy.setTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setTitleTitle, details.title)
        
        XCTAssertEqual(viewControllerSpy.setDescriptionCalls, 1)
        XCTAssertEqual(viewControllerSpy.setDescriptionDescription, details.description)
        
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setNegativeButtonTitleTitle, details.negativeActionTitle)
        
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleCalls, 1)
        XCTAssertEqual(viewControllerSpy.setPositiveButtonTitleTitle, details.positiveActionTitle)
    }
    
    func testClose() {
        
        sut.close()
        
        XCTAssertEqual(viewControllerSpy.closeCalls, 1)
    }
}
