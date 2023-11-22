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
    let beerFacade: BeerFacadeProtocol
    
    init(
        view: HomeViewController,
        beerFacade: BeerFacadeProtocol
    ) {
        self.view = view
        self.beerFacade = beerFacade
    }
    
    func setBeers(with beers: [Beer]) {
        view.setBeers(with: beers)
        
        if beers.count < 2 {
            view.setDefaultDataToRank()
        } else if let beer = BeerP().calculateMostValuable(beers: beers) {
            let economyValue = beerFacade.calcEconomyBetweenBeers(beer1: beer, beer2: beers[1])
            let economy = BeerP().formatValueToShow(value: economyValue)
            view.highligthBeer(beer, economy: economy)
        }
    }
}
