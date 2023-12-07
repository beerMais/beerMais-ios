//
//  AlertViewControllerSnapshot.swift
//  BeerMaisTests
//
//  Created by José Neves on 06/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

import SnapshotTesting

final class AlertViewControllerSnapshot: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }
    
    func testViewController() {
        
        let alertDetails = AlertInteractor.AlertDetails(
            title: "title",
            description: "description description description description",
            negativeActionTitle: "negative",
            positiveActionTitle: "positive"
        )
        let viewController = AlertFactory.build(with: alertDetails)
        
        assertSnapshot(of: viewController, as: .image)
    }
}
