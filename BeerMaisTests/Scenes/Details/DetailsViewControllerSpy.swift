//
//  DetailsViewControllerSpy.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import XCTest

final class DetailsViewControllerSpy: DetailsViewControllerProtocol {
    
    // MARK: - Calls
    
    var setupDataCalls: [SetupDataCall] = []
    
    var reloadBeersCalls: [ReloadBeersCall] = []
    
    var closeCalls: [CloseCall] = []
    
    var animateViewMovingCalls: [AnimateViewMovingCall] = []
    
    // MARK: - DetailsViewControllerProtocol
    
    func setupData(with beer: Beer) {
        setupDataCalls.append(.init(
            beer: beer
        ))
    }
    
    func reloadBeers() {
        reloadBeersCalls.append(.init())
    }
    
    func close() {
        reloadBeersCalls.append(.init())
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat) {
        animateViewMovingCalls.append(.init(
            up: up,
            moveValue: moveValue
        ))
    }
    
    // MARK: - Call structs
    
    struct SetupDataCall {
        let beer: Beer
    }
    
    struct ReloadBeersCall {}

    struct CloseCall {}

    struct AnimateViewMovingCall {
        let up: Bool
        let moveValue: CGFloat
    }
    
    
    
}
