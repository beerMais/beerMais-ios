//
//  SceneDelegate.swift
//  BeerMais Clip
//
//  Created by José Neves on 26/12/20.
//  Copyright © 2020 joseneves. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    @available(iOS 13.0, *)
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

