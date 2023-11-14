//
//  LaunchScreenViewController.swift
//  BeerMais
//
//  Created by José Neves on 13/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import UIKit

import Lottie


class LaunchScreenViewController: UIViewController {
    
    private let completionHandler: () -> Void
    
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BeerColors.primary
        
        let animationView = LottieAnimationView(name: "loading")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        
        let appNameLabel = UILabel()
        appNameLabel.text = "appName".localized
        appNameLabel.textAlignment = .center
        appNameLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        appNameLabel.textColor = .black
        
        view.addSubViews([
            animationView,
            appNameLabel
        ])
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24),
            
            animationView.widthAnchor.constraint(equalToConstant: 128),
            animationView.heightAnchor.constraint(equalToConstant: 128),
            
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.heightAnchor.constraint(equalToConstant: 30),
            appNameLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 22)
        ])
        
        animationView.play(completion: { [weak self] _ in
            self?.completionHandler()
        })
    }
}
