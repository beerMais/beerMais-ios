//
//  BeerTextInputSnapshot.swift
//  BeerMaisTests
//
//  Created by José Neves on 20/02/24.
//  Copyright © 2024 joseneves. All rights reserved.
//

import Foundation
import XCTest

import SnapshotTesting

final class BeerTextInputSnapshot: XCTestCase {
    
    override class func setUp() {
        isRecording = false
    }
    
    func testView() {
        
        let view = UIView()
        view.backgroundColor = .white
        view.frame = .init(x: 0, y: 0, width: 200, height: 300)
        
        let stackview = UIStackView()
        stackview.axis = .vertical
        
        let beerTextInput = BeerTextInput(placeholder: "Placeholder")
        let beerTextInputWithText = BeerTextInput(placeholder: "Placeholder")
        beerTextInputWithText.setText("Text")
        let beerTextInputWithHelperText = BeerTextInput(
            placeholder: "Placeholder",
            helperText: "HelperText"
        )
        let beerTextInputWithError = BeerTextInput(
            placeholder: "Placeholder"
        )
        beerTextInputWithError.showError(message: "Error")
        
        stackview.addArrangedSubviews([
            beerTextInput,
            beerTextInputWithText,
            beerTextInputWithHelperText,
            beerTextInputWithError
        ])
        
        view.addSubViews([stackview])
        
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        assertSnapshot(of: view, as: .image)
    }
}
