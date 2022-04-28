//
//  UIStackView+extensions.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

extension UIStackView {
    
    /// Receive an array of UIViews, set auto resizing flag and add as arranged sub view
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { [weak self] view in
            view.translatesAutoresizingMaskIntoConstraints = false
            
            self?.addArrangedSubview(view)
        }
    }
    
}
