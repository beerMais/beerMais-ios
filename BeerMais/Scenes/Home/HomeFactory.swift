//
//  HomeFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class HomeFactory {
    
    static func build() -> HomeViewController {
        let controller = HomeViewController()
        let presenter = HomePresenter(view: controller)
        let interactor = HomeInteractor(presenter: presenter)
        
        controller.interactor = interactor
        
        return controller
    }
}
