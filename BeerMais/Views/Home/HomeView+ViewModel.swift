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
        
        private let worker = BeerWorker()
        
        func reload() {
            beers = worker.getBeers()
            
            if beers.count >= 2 {
                highlightedBeer = beers.first
            }
        }
    }
}
