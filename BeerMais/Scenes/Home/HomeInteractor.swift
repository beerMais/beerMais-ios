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
    let beerWorker: BeerWorkerProtocol
    
    init(
        presenter: HomePresenter,
        beerWorker: BeerWorkerProtocol
    ) {
        self.presenter = presenter
        self.beerWorker = beerWorker
        
        reloadBeers()
    }
    
    func reloadBeers() {
        presenter.setBeers(with: beerWorker.getBeers())
    }
    
    func deleteAllBeers() {
        beerWorker.deleteAllBeers()
        reloadBeers()
    }
}
