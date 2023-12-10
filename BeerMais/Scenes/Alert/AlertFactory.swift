//
//  AlertFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 28/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class AlertFactory {
    
    static func build(with details: AlertInteractor.AlertDetails? = nil) -> AlertViewController {
        let controller = AlertViewController()
        let interactor = AlertInteractor(
            presenter: AlertPresenter(view: controller),
            details: details
        )
        
        controller.interactor = interactor
        
        return controller
    }
    
}
