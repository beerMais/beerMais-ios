//
//  AlertInteractorTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 23/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import Testing

struct AlertInteractorTests {
    private var presenter: AlertPresenterSpy

    init() throws {
        presenter = AlertPresenterSpy()
    }
    
    @Test
    mutating func negativeAction() {
        var actionCalls = 0
        let details = AlertInteractor.AlertDetails(negativeAction: {
            actionCalls += 1
        })
        
        let sut = AlertInteractor.mock(
            presenter: presenter,
            details: details
        )
        
        #expect(actionCalls == 0)
        #expect(presenter.closeCalls == 0)
        
        sut.negativeAction()
        
        #expect(actionCalls == 1)
        #expect(presenter.closeCalls == 1)
    }
    
    @Test
    mutating func positiveAction() {
        var actionCalls = 0
        let details = AlertInteractor.AlertDetails(positiveAction: {
            actionCalls += 1
        })
        
        let sut = AlertInteractor.mock(
            presenter: presenter,
            details: details
        )
        
        #expect(actionCalls == 0)
        #expect(presenter.closeCalls == 0)
        
        sut.positiveAction()
        
        #expect(actionCalls == 1)
        #expect(presenter.closeCalls == 1)
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
