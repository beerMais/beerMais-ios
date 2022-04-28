//
//  DetailsInteractor.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol DetailsInteractorProtocol {
    
}

final class DetailsInteractor: DetailsInteractorProtocol {
    
    private let presenter: DetailsPresenterProtocol
    private var beer: Beer?
    
    init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    convenience init(presenter: DetailsPresenterProtocol, beer: Beer?) {
        self.init(presenter: presenter)
        
        if let currentBeer = beer {
            self.beer = currentBeer
            presenter.setupData(with: currentBeer)
        }
    }
}
