//
//  BeerTextField.swift
//  BeerMais
//
//  Created by Jose Neves on 26/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class BeerTextField: MDCTextField {
    
    static func build() -> BeerTextField {
        let textField = BeerTextField()
        
        return textField
    }
}

class BeerTextInputController: MDCTextInputControllerOutlined {
    
    static func build(textInput input: (UIView & MDCTextInput)?) -> BeerTextInputController {
        let controller = BeerTextInputController(textInput: input)
        controller.applyStyle()
        
        return controller
    }
    
    private func applyStyle() {
        inlinePlaceholderColor =  BeerColors.blackWhite
        floatingPlaceholderNormalColor =  BeerColors.blackWhite
        leadingUnderlineLabelTextColor =  BeerColors.blackWhite
        textInput?.textColor =  BeerColors.blackWhite
    }
}
