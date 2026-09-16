//
//  HomeView+ViewModel.swift
//  BeerMais
//
//  Created by José Neves on 09/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

extension HomeView {
    final class ViewModel: ObservableObject {
        @Published var beers: [Beer] = []
        @Published var highlightedBeer: Beer? = nil
        @Published var economy: Float? = nil
        
        let highlightedBeerViewModel: BeerView.ViewModel
        let worker: BeerWorkerProtocol

        init(worker: BeerWorkerProtocol) {
            self.worker = worker
            highlightedBeerViewModel = BeerView.ViewModel(isHighlighted: true, worker: worker)
        }
        
        func reload() {
            beers = worker.getBeers()
            
            if let (mostValuableBeer, economy) = worker.calculateMostValuableBeer(beers: beers) {
                highlightedBeer = mostValuableBeer
                self.economy = economy
            } else {
                highlightedBeer = nil
                economy = nil
            }
            // Refresh even when the managed object identity or savings did not change.
            highlightedBeerViewModel.beer = highlightedBeer
            highlightedBeerViewModel.economy = economy
        }
    }
}
