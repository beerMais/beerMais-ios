//
//  SuccessFeedbackView.swift
//  BeerMais
//
//  Created by José Neves on 12/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import UIKit

import Lottie


final class SuccessFeedbackView {
    
    private var animationView: LottieAnimationView?
    private var topController: UIViewController?
    
    func show(secondsToStop: Int = 7) {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        guard var topController = keyWindow?.rootViewController else {
            return
        }
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        self.topController = topController
        
        animationView = .init(name: "success")
        
        guard let animationView else { return }
        
        animationView.frame = topController.view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = secondsToStop == 0 ? .playOnce : .loop
        animationView.animationSpeed = 1

        topController.view.addSubview(animationView)

        animationView.play()
        
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(secondsToStop), repeats: false, block: { [weak self] timer in
            self?.stop()
            timer.invalidate()
        })
    }
    
    func stop() {
        animationView?.stop()
        topController?.view.subviews.first(where: { $0 == animationView })?.removeFromSuperview()

        animationView = nil
    }
}
