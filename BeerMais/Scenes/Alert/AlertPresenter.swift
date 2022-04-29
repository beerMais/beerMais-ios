//
//  AlertPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 28/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol AlertPresenterProtocol {
    func setupData(with details: AlertInteractor.AlertDetails)
    func close()
}

final class AlertPresenter {
    
    private var view: AlertViewControllerProtocol
    
    init(view: AlertViewControllerProtocol) {
        self.view = view
    }
    
}

extension AlertPresenter: AlertPresenterProtocol {
    
    func setupData(with details: AlertInteractor.AlertDetails) {
        view.setTitle(title: details.title ?? "")
        view.setDescription(description: details.description ?? "")
        view.setNegativeButtonTitle(title: details.negativeActionTitle ?? "")
        view.setPositiveButtonTitle(title: details.positiveActionTitle ?? "")
    }
    
    func close() {
        view.close()
    }
}
