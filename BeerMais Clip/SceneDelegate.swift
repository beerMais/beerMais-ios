//
//  SceneDelegate.swift
//  BeerMais Clip
//
//  Created by José Neves on 26/12/20.
//  Copyright © 2020 joseneves. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let dependencies = AppDependencies()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(
                rootView: MainView().environment(\.appDependencies, dependencies)
            )
            
            self.window = window
            
            window.makeKeyAndVisible()
        }
    }
}
