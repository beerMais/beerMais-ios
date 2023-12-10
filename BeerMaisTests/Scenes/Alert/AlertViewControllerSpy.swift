//
//  AlertViewControllerSpy.swift
//  BeerMaisTests
//
//  Created by José Neves on 23/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

final class AlertViewControllerSpy: AlertViewControllerProtocol {
    
    // MARK: - Calls
    
    var setTitleCalls: [SetTitleCall] = []
    
    var setDescriptionCalls: [SetDescriptionCall] = []
    
    var setNegativeButtonTitleCalls: [SetNegativeButtonTitleCall] = []
    
    var setPositiveButtonTitleCalls: [SetPositiveButtonTitleCall] = []
    
    var closeCalls: [CloseCall] = []
    
    // MARK: - AlertViewControllerProtocol

    func setTitle(title: String) {
        setTitleCalls.append(.init(
            title: title
        ))
    }
    
    func setDescription(description: String) {
        setDescriptionCalls.append(.init(
            description: description
        ))
    }
    
    func setNegativeButtonTitle(title: String) {
        setNegativeButtonTitleCalls.append(.init(
            title: title
        ))
    }
    
    func setPositiveButtonTitle(title: String) {
        setPositiveButtonTitleCalls.append(.init(
            title: title
        ))
    }
    
    func close() {
        closeCalls.append(.init())
    }
    
    // MARK: - Call structs
    
    struct SetTitleCall {
        let title: String
    }
    
    struct SetDescriptionCall {
        let description: String

    }
    
    struct SetNegativeButtonTitleCall {
        let title: String

    }
    
    struct SetPositiveButtonTitleCall {
        let title: String

    }
    
    struct CloseCall {}
}
