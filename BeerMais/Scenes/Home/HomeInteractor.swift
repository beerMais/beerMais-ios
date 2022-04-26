//
//  HomeInteractor.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol HomeInteractorProtocol {

}

final class HomeInteractor: HomeInteractorProtocol {
    
    private let presenter: HomePresenterProtocol
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        
        getBeers()
    }
    
    private func getBeers() {
        BeerP().getBeers() { [weak self] beers in
            self?.presenter.setBeers(with: beers)
        }
    }
}
