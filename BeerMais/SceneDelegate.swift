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
            
            let homeNavController = UINavigationController(rootViewController: HomeFactory.build())
            homeNavController.tabBarItem = UITabBarItem(title: "Calculadora",
                                                    image: UIImage(named: "icons8-math-50"),
                                                    tag: 0)
            homeNavController.tabBarItem.image?.withTintColor(.red)
            
            let aboutController = AboutFactory.build()
            aboutController.tabBarItem = UITabBarItem(title: "Sobre",
                                                    image: UIImage(named: "icons8-about-50"),
                                                    tag: 1)
            
            let tabBarController = UITabBarController()
            tabBarController.tabBar.tintColor = BeerColors.primaryLight
            tabBarController.tabBar.barTintColor = .tertiarySystemBackground
            tabBarController.tabBar.backgroundColor = .clear
            tabBarController.tabBar.isTranslucent = false
            tabBarController.viewControllers = [
                homeNavController,
                aboutController
            ]
            
            window.rootViewController = tabBarController
            
            self.window = window
            
            window.makeKeyAndVisible()
        }

    }
    
}
