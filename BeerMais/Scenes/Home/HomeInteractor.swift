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
    
    // MARK: - Injected Properties
    
    let presenter: HomePresenterProtocol
    let beerFacade: BeerFacadeProtocol
    
    init(
        presenter: HomePresenter,
        beerFacade: BeerFacadeProtocol
    ) {
        self.presenter = presenter
        self.beerFacade = beerFacade
        
        reloadBeers()
    }
    
    func reloadBeers() {
        presenter.setBeers(with: beerFacade.getBeers())
    }
    
    func deleteAllBeers() {
        beerFacade.deleteAllBeers()
        reloadBeers()
    }
}
