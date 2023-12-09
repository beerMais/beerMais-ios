//
//  HomeViewControllerSnapshot.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import XCTest

import SnapshotTesting

final class HomeViewControllerSnapshot: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }
    
    func testEmptyViewController() {
        let viewController = HomeFactory.build()
        
        assertSnapshot(of: viewController, as: .image)
    }
    
    func testViewController() {
        
        let beer = Beer.mock()
        beer.brand = "brand1"
        beer.value = 10
        beer.amount = 1000
        beer.type = 2

        let beer2 = Beer.mock()
        beer2.brand = "brand2"
        beer2.value = 11.0
        beer2.amount = 1000
        beer2.type = 2
        
        let beerWorker = BeerWorkerStub()
        beerWorker.getBeersReturn = [
            beer,
            beer2
        ]
        beerWorker.calculateMostValuableBeerReturn = beer
        beerWorker.calcEconomyBetweenBeersReturn = 1
        beerWorker.formatBeerValueToShowReturn = "1,10"
        
        let viewController = HomeFactory.build(beerWorker: beerWorker)
        
        assertSnapshot(of: viewController, as: .image)
    }
}
