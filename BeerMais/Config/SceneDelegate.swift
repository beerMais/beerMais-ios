//
//  SceneDelegate.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let navigationController = UINavigationController()
            
            let completionHandler = {
                let homeNavController = UINavigationController(rootViewController: HomeFactory.build())
                homeNavController.tabBarItem = UITabBarItem(
                    title: "Calculadora",
                    image: UIImage(named: "icons8-math-50"),
                    tag: 0
                )
                
                let aboutController = AboutFactory.build()
                aboutController.tabBarItem = UITabBarItem(
                    title: "Sobre",
                    image: UIImage(named: "icons8-about-50"),
                    tag: 1
                )
                
                let tabBarController = UITabBarController()
                tabBarController.tabBar.tintColor = BeerColors.primaryLight
                tabBarController.tabBar.barTintColor = .tertiarySystemBackground
                tabBarController.tabBar.backgroundColor = .systemBackground
                tabBarController.viewControllers = [
                    homeNavController,
                    aboutController
                ]
                
                tabBarController.modalPresentationStyle = .overFullScreen
                navigationController.present(tabBarController, animated: true, completion: {
                    navigationController.viewControllers.first?.removeFromParent()
                })
            }
            
            navigationController.viewControllers = [
                LaunchScreenViewController(
                    completionHandler: completionHandler
                )
            ]
            
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }

    }
    
}
