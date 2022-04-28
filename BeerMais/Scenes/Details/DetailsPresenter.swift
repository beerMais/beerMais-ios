//
//  DetailsPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol DetailsPresenterProtocol {
    func setupData(with beer: Beer)
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    private let view: DetailsViewControllerProtocol
 
    init(view: DetailsViewControllerProtocol) {
        self.view = view
    }
    
    func setupData(with beer: Beer) {
        view.setupData(with: beer)
    }
}
