//
//  StringExtensions.swift
//  BeerMais
//
//  Created by José Neves on 25/08/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .beerMais, comment: "")
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
