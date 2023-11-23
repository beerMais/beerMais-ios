//
//  HomePresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol HomePresenterProtocol {
    func setBeers(with beers: [Beer])
}

final class HomePresenter: HomePresenterProtocol {
    
    // MARK: - Injected Properties
    
    let view: HomeViewController
    let beerWorker: BeerWorkerProtocol
    
    init(
        view: HomeViewController,
        beerWorker: BeerWorkerProtocol
    ) {
        self.view = view
        self.beerWorker = beerWorker
    }
    
    func setBeers(with beers: [Beer]) {
        view.setBeers(with: beers)
        
        if beers.count < 2 {
            view.setDefaultDataToRank()
        } else if let beer = beerWorker.calculateMostValuableBeer(beers: beers) {
            let economyValue = beerWorker.calcEconomyBetweenBeers(beer1: beer, beer2: beers[1])
            view.highligthBeer(
                beer,
                economy: beerWorker.formatBeerValueToShow(value: economyValue)
            )
        }
    }
}
