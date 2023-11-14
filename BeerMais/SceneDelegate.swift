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
            
            window.rootViewController = LaunchScreenViewController()
            self.window = window
            window.makeKeyAndVisible()

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
            
            _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] timer in
                let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
                tabBarController.view.addSubview(overlayView)

                UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
                    self?.window?.rootViewController = tabBarController
                    overlayView.alpha = 0
                }, completion: { finished in
                    overlayView.removeFromSuperview()
                    timer.invalidate()
                })
            })
        }

    }
    
}
