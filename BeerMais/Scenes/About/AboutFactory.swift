//
//  AboutFactory.swift
//  BeerMais
//
//  Created by Jose Neves on 01/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

final class AboutFactory {
    
    static func build(
        remoteConfig: RemoteConfigProtocol = AppP.remoteConfig
    ) -> AboutViewController {
        let controller = AboutViewController()
        let presenter = AboutPresenter(view: controller)
        let interactor = AboutInteractor(
            presenter: presenter,
            remoteConfig: remoteConfig
        )
        
        controller.interactor = interactor
        
        return controller
    }
}
