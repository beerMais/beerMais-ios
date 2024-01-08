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
    
    // MARK: - Injected Properties
    
    private let presenter: AboutPresenterProtocol
    private let remoteConfig: RemoteConfigProtocol
    
    // MARK: - Initialization
    
    init(
        presenter: AboutPresenterProtocol,
        remoteConfig: RemoteConfigProtocol
    ) {
        self.presenter = presenter
        self.remoteConfig = remoteConfig
        
        var availableRows: [AboutRow] = [
            .description,
            .version
        ]
        
        if remoteConfig.configValue(forKey: "is_donate_available").boolValue {
            availableRows.insert(.donate, at: 1)
        }
        
        showItems(with: availableRows)
    }
    
    private func showItems(with availableRows: [AboutRow]) {
        presenter.showItems(with: availableRows)
    }
}

// MARK: - AboutInteractorProtocol

extension AboutInteractor: AboutInteractorProtocol {
    
}
