//
//  SceneDelegate.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let navigationController = UINavigationController()
            let main = UIHostingController(
                rootView: MainView().interactiveDismissDisabled()
            )
            
            if #available(iOS 26.0, *) {} else {
                main.modalPresentationStyle = .overFullScreen
            }
            
            navigationController.viewControllers = [
                LaunchScreenViewController(
                    completionHandler: {
                        navigationController.present(main, animated: true)
                    }
                )
            ]
            
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }

    }
    
}
