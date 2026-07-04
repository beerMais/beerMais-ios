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


@MainActor
final class LoadingView {
    
    private weak var keyWindow: UIWindow?
    private var backgroundView: UIView?
    private var animationView: LottieAnimationView?
    
    func show() {
        guard animationView == nil || keyWindow == nil else { return }
        
        keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let keyWindow else {
            return
        }
        
        let backgroundView = UIView(frame: keyWindow.bounds)
        backgroundView.backgroundColor = .clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        keyWindow.addSubview(backgroundView)
        
        let animationView = LottieAnimationView(name: "loading")
        animationView.frame = keyWindow.bounds
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
            backgroundView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            
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
                self?.backgroundView?.removeFromSuperview()
                
                self?.keyWindow = nil
                self?.backgroundView = nil
                self?.animationView = nil
            }
        )
    }
}
