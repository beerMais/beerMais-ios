//
//  DetailsViewControllerSpy.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import XCTest

final class DetailsViewControllerSpy: DetailsViewControllerProtocol {
    
    var setupDataCalls = 0
    var setupDataBeer: Beer?
    func setupData(with beer: Beer) {
        setupDataCalls += 1
        setupDataBeer = beer
    }
    
    var reloadBeersCalls = 0
    func reloadBeers() {
        reloadBeersCalls += 1
    }
    
    var closeCalls = 0
    func close() {
        closeCalls += 1
    }
    
    var animateViewMovingCalls = 0
    var animateViewMovingUp: Bool?
    var animateViewMovingMoveValue: CGFloat?
    func animateViewMoving(up: Bool, moveValue: CGFloat) {
        animateViewMovingCalls += 1
        animateViewMovingUp = up
        animateViewMovingMoveValue = moveValue
    }
    
    
}
