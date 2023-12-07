//
//  DetailsViewControllerSnapshot.swift
//  BeerMaisTests
//
//  Created by José Neves on 05/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

import SnapshotTesting

class DetailsViewControllerSnapshot: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }

    func testViewController() {
        let vc = DetailsFactory.build()

        assertSnapshot(of: vc, as: .image)
    }

    func testViewControllerWithBeer() {
        
        let beer = Beer.mock()
        beer.amount = 350
        beer.brand = "test brand"
        beer.value = 2.59
        beer.type = 1
        
        let vc = DetailsFactory.build(with: beer)

        assertSnapshot(of: vc, as: .image)
    }
}
