//
//  BeerButton.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons_ColorThemer

class BeerButton: MDCButton {
    
    enum ButtonStyle {
        case positive
        case negative
    }
    
    static func build(style: ButtonStyle = .positive) -> BeerButton {
        let button = BeerButton()
        
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        
        button.shapeGenerator = shapeGenerator
        button.applyStyle(style)
        button.setElevation(ShadowElevation(1), for: .normal)
        
        button.isUppercaseTitle = false
        button.setTitleColor(BeerColors.whiteBlack, for: .normal)
        button.setTitleFont(UIFont.systemFont(ofSize: 16, weight: .medium), for: .normal)
        
        return button
    }
    
    func applyStyle(_ style: ButtonStyle) {
        let containerScheme = MDCContainerScheme()
        
        switch style {
        case .positive:
            let positiveColorScheme = MDCSemanticColorScheme()
            positiveColorScheme.primaryColor = UIColor(red: 0.04, green: 0.69, blue: 0.00, alpha: 1.0)
            
            containerScheme.colorScheme = positiveColorScheme
        case .negative:
            let negativeColorScheme = MDCSemanticColorScheme()
            negativeColorScheme.primaryColor = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0)
            
            containerScheme.colorScheme = negativeColorScheme
        }
        
        applyContainedTheme(withScheme: containerScheme)
    }
}
