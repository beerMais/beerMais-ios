//
//  UIView+extensions.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Receive an array of UIViews, set auto resizing flag and add as sub view
    func addSubViews(_ views: [UIView]) {
        views.forEach { [weak self] view in
            view.translatesAutoresizingMaskIntoConstraints = false
            
            self?.addSubview(view)
        }
    }
    
}
