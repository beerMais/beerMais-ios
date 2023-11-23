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
        beerWorker: BeerWorkerProtocol = BeerWorker()
    ) -> HomeViewController {
        let controller = HomeViewController()
        let interactor = HomeInteractor(
            presenter: HomePresenter(
                view: controller,
                beerWorker: beerWorker
            ),
            beerWorker: beerWorker
        )
        
        controller.interactor = interactor
        
        return controller
    }
}
