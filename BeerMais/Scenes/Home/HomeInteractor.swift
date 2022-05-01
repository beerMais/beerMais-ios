//
//  HomeInteractor.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol HomeInteractorProtocol {
    func reloadBeers()
    func deleteAllBeers()
}

final class HomeInteractor: HomeInteractorProtocol {
    
    private let presenter: HomePresenterProtocol
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        
        reloadBeers()
    }
    
    func reloadBeers() {
        BeerP().getBeers() { [weak self] beers in
            self?.presenter.setBeers(with: beers)
        }
    }
    
    func deleteAllBeers() {
        BeerP().deleteBeers()
        presenter.setBeers(with: [])
    }
}
