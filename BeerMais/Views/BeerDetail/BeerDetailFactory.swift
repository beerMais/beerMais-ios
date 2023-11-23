//
//  BeerDetailFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class BeerDetailFactory {
    
    static func build(
        with beer: Beer? = nil,
        delegate: DetailsViewControllerProtocol? = nil,
        beerWorker: BeerWorkerProtocol = BeerWorker()
    ) -> BeerDetailView {
        let view = BeerDetailView()
        let presenter = BeerDetailPresenter(
            view: view, 
            beer: beer,
            beerWorker: beerWorker
        )
        
        view.presenter = presenter
        view.delegate = delegate
        
        return view
    }
}
