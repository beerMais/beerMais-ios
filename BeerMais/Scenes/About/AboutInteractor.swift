//
//  AboutInteractor.swift
//  BeerMais
//
//  Created by Jose Neves on 01/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

protocol AboutInteractorProtocol {
    
}

enum AboutRow {
    case description
    case donate
    case version
}

final class AboutInteractor {
    
    private var presenter: AboutPresenterProtocol
    private var availableRows: [AboutRow] = [
        .description,
        .donate,
        .version
    ]
    
    init(presenter: AboutPresenterProtocol) {
        self.presenter = presenter
        
        showItems(with: availableRows)
    }
    
    private func showItems(with availableRows: [AboutRow]) {
        presenter.showItems(with: availableRows)
    }
}

extension AboutInteractor: AboutInteractorProtocol {
    
}
