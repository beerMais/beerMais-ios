//
//  AboutFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 01/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class AboutFactory {
    
    static func build() -> AboutViewController {
        let controller = AboutViewController()
        let presenter = AboutPresenter(view: controller)
        let interactor = AboutInteractor(presenter: presenter)
        
        controller.interactor = interactor
        
        return controller
    }
}
