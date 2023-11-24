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
    
    var setTitleTitle: String?
    var setTitleCalls = 0
    func setTitle(title: String) {
        setTitleTitle = title
        setTitleCalls += 1
    }
    
    var setDescriptionDescription: String?
    var setDescriptionCalls = 0
    func setDescription(description: String) {
        setDescriptionDescription = description
        setDescriptionCalls += 1
    }
    
    var setNegativeButtonTitleTitle: String?
    var setNegativeButtonTitleCalls = 0
    func setNegativeButtonTitle(title: String) {
        setNegativeButtonTitleTitle = title
        setNegativeButtonTitleCalls += 1
    }
    
    var setPositiveButtonTitleTitle: String?
    var setPositiveButtonTitleCalls = 0
    func setPositiveButtonTitle(title: String) {
        setPositiveButtonTitleTitle = title
        setPositiveButtonTitleCalls += 1
    }
    
    var closeCalls = 0
    func close() {
        closeCalls += 1
    }
}
