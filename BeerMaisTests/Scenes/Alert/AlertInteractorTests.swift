//
//  AlertInteractorTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 23/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

final class AlertInteractorTests: XCTest {
    
    var sut: AlertInteractor!
    var presenter: AlertPresenterSpy!
    
    override func setUp() {
        presenter = AlertPresenterSpy()
        sut = AlertInteractor.mock(presenter: presenter)
    }
    
    override func tearDown() {
        sut =  nil
        presenter =  nil
    }

    func testNegativeAction() {
        
        var negativeActionCalls = 0
        let details = AlertInteractor.AlertDetails(negativeAction: {
            negativeActionCalls += 1
        })
        
        sut = AlertInteractor.mock(
            presenter: presenter,
            details: details
        )
        
        XCTAssertEqual(negativeActionCalls, 0)
        XCTAssertEqual(presenter.closeCalls, 0)
        
        sut.negativeAction()
        
        XCTAssertEqual(negativeActionCalls, 1)
        XCTAssertEqual(presenter.closeCalls, 1)
    }

    func testPositiveAction() {
        
        var positiveActionCalls = 0
        let details = AlertInteractor.AlertDetails(positiveAction: {
            positiveActionCalls += 1
        })
        
        sut = AlertInteractor.mock(
            presenter: presenter,
            details: details
        )
        
        XCTAssertEqual(positiveActionCalls, 0)
        XCTAssertEqual(presenter.setupDataCalls, 0)
        sut.positiveAction()
        
        XCTAssertEqual(positiveActionCalls, 1)
        XCTAssertEqual(presenter.setupDataCalls, 1)
    }
}

extension AlertInteractor {
    
    static func mock(
        presenter: AlertPresenterProtocol = AlertPresenterSpy(),
        details: AlertDetails? = nil
    ) -> AlertInteractor {
        .init(
            presenter: presenter,
            details: details
        )
    }
}


final class AlertPresenterSpy: AlertPresenterProtocol {
    
    var setupDataDetails: AlertInteractor.AlertDetails?
    var setupDataCalls = 0
    func setupData(with details: AlertInteractor.AlertDetails) {
        setupDataDetails = details
        setupDataCalls += 1
    }
    
    var closeCalls = 0
    func close() {
        closeCalls += 1
    }
}
