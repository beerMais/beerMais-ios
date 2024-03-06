//
//  BeerTextField.swift
//  BeerMais
//
//  Created by Jose Neves on 26/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import BasicsKit

final class BeerTextField: UITextField {
    
    // MARK: - Private properties
    
    private let textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
}
