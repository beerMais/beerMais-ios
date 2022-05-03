//
//  BeerDetailTestsFactory.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class BeerDetailTestsFactory {
    
    static func build(with spy: BeerDetailViewSpy,
                      beer: Beer? = nil) -> BeerDetailPresenter {
        let presenter = BeerDetailPresenter(view: spy, beer: beer)
        
        return presenter
    }
}
