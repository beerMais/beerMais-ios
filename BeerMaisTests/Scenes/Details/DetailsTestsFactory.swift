//
//  DetailsTestsFactory.swift
//  BeerMaisTests
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import XCTest

final class DetailsTestsFactory {
    
    static func build(with spy: DetailsViewControllerSpy,
                      beer: Beer? = nil) -> DetailsInteractor {
        let presenter = DetailsPresenter(view: spy)
        let interactor = DetailsInteractor(presenter: presenter, beer: beer)
        
        return interactor
    }
}
