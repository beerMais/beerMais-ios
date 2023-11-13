//
//  LoadingView.swift
//  BeerMais
//
//  Created by José Neves on 12/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import UIKit

import Lottie


final class LoadingView {
    
    private var topViewController: UIViewController?
    private var backgroundView: UIView?
    private var animationView: LottieAnimationView?
    
    func show() {
        
        guard animationView == nil || topViewController == nil else { return }
        
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        guard var topViewController = keyWindow?.rootViewController else {
            return
        }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        self.topViewController = topViewController
        
        let backgroundView = UIView(frame: topViewController.view.frame)
        backgroundView.backgroundColor = .clear
        topViewController.view.addSubview(backgroundView)
        
        let animationView = LottieAnimationView(name: "loading")
        animationView.frame = topViewController.view.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 1
        animationView.alpha = 0

        backgroundView.addSubViews([animationView])

        animationView.play()
        
        UIView.transition(
            with: animationView,
            duration: 0.2,
            options: [.transitionCrossDissolve],
            animations: {
                backgroundView.backgroundColor = .black.withAlphaComponent(0.6)
                animationView.alpha = 0.9
            }, 
            completion: nil
        )
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 48),
            animationView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -48),
            
            animationView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -32)
        ])
        
        self.backgroundView = backgroundView
        self.animationView = animationView
    }
    
    func hide() {
        
        guard let animationView else { return }
        
        UIView.transition(
            with: animationView,
            duration: 0.2,
            options: [.transitionCrossDissolve],
            animations: { [weak self] in
                self?.backgroundView?.backgroundColor = .clear
                self?.animationView?.alpha = 0
            },
            completion: { [weak self] _ in
                self?.animationView?.stop()
                self?.topViewController?.view.subviews.first(where: { $0 == self?.backgroundView })?.removeFromSuperview()
                
                self?.topViewController = nil
                self?.backgroundView = nil
                self?.animationView = nil
            }
        )
    }
}
