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
    
    private let view: HomeViewController
    
    init(view: HomeViewController) {
        self.view = view
    }
    
    func setBeers(with beers: [Beer]) {
        view.setBeers(with: beers)
        
        if beers.count < 2 {
            view.setDefaultDataToRank()
        } else if let beer = BeerP().calculateMostValuable(beers: beers) {
            let economyValue = BeerP().getEconomy(beer1: beer, beer2: beers[1])
            let economy = BeerP().formatValueToShow(value: economyValue)
            view.highligthBeer(beer, economy: economy)
        }
    }
}
