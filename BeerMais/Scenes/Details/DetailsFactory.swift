//
//  DetailsFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class DetailsFactory {
    static func build(with beer: Beer? = nil,
                      delegate: HomeViewControllerProtocol? = nil) -> DetailsViewController {
        let controller = DetailsViewController()
        let presenter = DetailsPresenter(view: controller)
        let interactor = DetailsInteractor(presenter: presenter, beer: beer)
        
        controller.interactor = interactor
        controller.delegate = delegate
        
        return controller
    }
}
