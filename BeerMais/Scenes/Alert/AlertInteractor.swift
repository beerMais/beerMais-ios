//
//  AlertInteractor.swift
//  BeerMais
//
//  Created by Jose Neves on 28/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol AlertInteractorProtocol {
    func negativeAction()
    func positiveAction()
}

final class AlertInteractor {
    
    struct AlertDetails {
        var title: String?
        var description: String?
        var negativeActionTitle: String?
        var positiveActionTitle: String?
        var negativeAction: (() -> Void)?
        var positiveAction: (() -> Void)?
    }
    
    var presenter: AlertPresenterProtocol
    var details: AlertDetails?
    
    init(presenter: AlertPresenterProtocol, details: AlertDetails?) {
        self.presenter = presenter
        self.details = details
        
        if let details {
            presenter.setupData(with: details)
        }
    }
    
}

extension AlertInteractor: AlertInteractorProtocol {
    func negativeAction() {
        details?.negativeAction?()
        presenter.close()
    }
    
    func positiveAction() {
        details?.positiveAction?()
        presenter.close()
    }
}
