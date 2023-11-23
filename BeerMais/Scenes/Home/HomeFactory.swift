//
//  HomeFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class HomeFactory {
    
    static func build(
        beerFacade: BeerFacadeProtocol = BeerFacade()
    ) -> HomeViewController {
        let controller = HomeViewController()
        let interactor = HomeInteractor(
            presenter: HomePresenter(
                view: controller,
                beerFacade: beerFacade
            ),
            beerFacade: beerFacade
        )
        
        controller.interactor = interactor
        
        return controller
    }
}
