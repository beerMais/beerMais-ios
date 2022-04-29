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
        let presenter = AlertPresenter(view: controller)
        
        var interactor: AlertInteractor
        if let details = details {
            interactor = AlertInteractor(presenter: presenter, details: details)
        } else {
            interactor = AlertInteractor(presenter: presenter)
        }
        
        controller.interactor = interactor
        
        return controller
    }
    
}
