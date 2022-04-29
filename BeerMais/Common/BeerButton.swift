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
        case neutral
    }
    
    static func build(style: ButtonStyle = .positive) -> BeerButton {
        let button = BeerButton()
        button.applyStyle(style)
        
        button.isUppercaseTitle = false
        button.setTitleFont(UIFont.systemFont(ofSize: 16, weight: .medium), for: .normal)
        
        return button
    }
    
    func applyStyle(_ style: ButtonStyle) {
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        
        self.shapeGenerator = shapeGenerator
        
        let containerScheme = MDCContainerScheme()
        let colorScheme = MDCSemanticColorScheme()
        containerScheme.colorScheme = colorScheme
        
        switch style {
        case .positive:
            colorScheme.primaryColor = UIColor(red: 0.04, green: 0.69, blue: 0.00, alpha: 1.0)
        case .negative:
            colorScheme.primaryColor = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0)
        case .neutral:
            backgroundColor = .clear
            setTitleColor(BeerColors.blackWhite, for: .normal)
        }
        
        if style != .neutral {
            setTitleColor(BeerColors.whiteBlack, for: .normal)
            setElevation(ShadowElevation(1), for: .normal)
            
            applyContainedTheme(withScheme: containerScheme)
        }
    }
}
