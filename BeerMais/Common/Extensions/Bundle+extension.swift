//
//  Bundle+extension.swift
//  BeerMais
//
//  Created by José Neves on 06/12/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation

extension Bundle {
    static let beerMais: Bundle = {
        .init(for: Beer.self)
    }()
}
