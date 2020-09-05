//
//  AlertVC.swift
//  BeerMais
//
//  Created by Jose Neves on 22/01/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons_ColorThemer

class AlertVC: UIViewController {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var negativeButton: MDCButton!
    @IBOutlet weak var positiveButton: MDCButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    private var negativeAction: (() -> Void)?
    private var positiveAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalView.layer.cornerRadius = 10
        self.addStyleToButtons()
        
        self.negativeButton.isUppercaseTitle = false
        self.positiveButton.isUppercaseTitle = false
        
        self.bodyLabel.baselineAdjustment = .alignCenters
        
        self.addBannerView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        if !self.modalView.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func negativeAction(_ sender: Any) {
        if self.negativeAction != nil {
            self.negativeAction!()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func positiveAction(_ sender: Any) {
        if self.positiveAction != nil {
            self.positiveAction!()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setNegativeAction(_ action: (() -> Void)? = nil, text: String) {
        self.negativeAction = action
        self.negativeButton.setTitle(text, for: .normal)
    }
    
    func setPositiveAction(_ action: (() -> Void)? = nil, text: String) {
        self.positiveAction = action
        self.positiveButton.setTitle(text, for: .normal)
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setBody(body: String) {
        self.bodyLabel.text = body
    }
    
    private func addBannerView() {
        self.bannerView.adUnitID = SettingsP().getAdMobBeerBannerID()
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
    }
    
    private func addStyleToButtons() {
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        self.negativeButton.shapeGenerator = shapeGenerator
        self.positiveButton.shapeGenerator = shapeGenerator
        
        let positiveColorScheme = MDCSemanticColorScheme()
        positiveColorScheme.primaryColor = UIColor(red: 0.04, green: 0.69, blue: 0.00, alpha: 1.0)
        
        let positiveCS = MDCContainerScheme()
        positiveCS.colorScheme = positiveColorScheme
        self.positiveButton.applyContainedTheme(withScheme: positiveCS)
        
        self.positiveButton.setElevation(ShadowElevation(1), for: .normal)
    }
}
