//
//  AboutPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 01/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol AboutPresenterProtocol {
    func showItems(with availableRows: [AboutRow])
}

final class AboutPresenter {
    
    private var view: AboutViewControllerProtocol
    
    init(view: AboutViewControllerProtocol) {
        self.view = view
    }
    
}

extension AboutPresenter: AboutPresenterProtocol {
    func showItems(with availableRows: [AboutRow]) {
        view.showItems(with: availableRows)
    }
}
