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
    private let dependencies = AppDependencies()

    func sceneDidBecomeActive(_ scene: UIScene) {
        dependencies.beerWorker.refreshWidgetData()
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            #if DEBUG
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               appDelegate.isFirstLaunch {
                AppP.seedInitialData(using: dependencies.beerWorker)
            }
            #endif
            
            let navigationController = UINavigationController()
            let main = UIHostingController(
                rootView: MainView()
                    .environment(\.appDependencies, dependencies)
                    .interactiveDismissDisabled()
            )
            main.isModalInPresentation = true
            if #available(iOS 26.0, *) {
                main.modalPresentationStyle = .pageSheet
                main.sheetPresentationController?.detents = [.large()]
            } else {
                main.modalPresentationStyle = .overFullScreen
            }
            let launch = LaunchScreenViewController { [weak navigationController] in
                navigationController?.present(main, animated: true)
            }
            navigationController.viewControllers = [launch]
            window.rootViewController = navigationController

            self.window = window
            window.makeKeyAndVisible()
        }

    }
    
}
