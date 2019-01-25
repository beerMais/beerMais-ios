//
//  NewBeerVC.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MaterialButtons_ColorThemer
import MaterialComponents.MaterialTextFields

class NewBeerVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var brandTextField: MDCTextField!
    @IBOutlet weak var valueTextField: MDCTextField!
    @IBOutlet weak var amountTextField: MDCTextField!
    @IBOutlet weak var addButton: MDCButton!
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var closeButton: MDCFloatingButton!
    @IBOutlet weak var deleteButton: MDCButton!
    @IBOutlet weak var saveButton: MDCButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var resumeBeers: ResumeBeersVCDelegate!
    private var beer: Beer!
    private var beerPresenter: BeerPresenter!
    
    private var brandController: MDCTextInputControllerOutlined?
    private var valueController: MDCTextInputControllerOutlined?
    private var amountController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBannerView()
        
        self.beerPresenter = BeerPresenter()
        
        self.modalView.layer.cornerRadius = 10
        self.addStyleToFields()
        self.addStyleToButtons()
        
        self.addDelegates()
        self.populateBeer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        
        if !self.modalView.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        if (!self.isValidBeer()) {
            return
        }
        _ = self.beerPresenter.create(data: self.getBeerArray())
        
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if (self.beer == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.beerPresenter.delete(beer: self.beer)
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        if (self.beer == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if (!self.isValidBeer()) {
            return
        }
        
        self.beerPresenter.edit(beer: self.beer, data: self.getBeerArray())
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateViewMoving(up: false, moveValue: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func attachResumeBeersDelegate(delegate: ResumeBeersVCDelegate) {
        self.resumeBeers = delegate
    }
    
    func setBeer(beer: Beer) {
        self.beer = beer
    }
    
    private func addStyleToFields() {
        self.brandController = MDCTextInputControllerOutlined(textInput: self.brandTextField)
        self.valueController = MDCTextInputControllerOutlined(textInput: self.valueTextField)
        self.amountController = MDCTextInputControllerOutlined(textInput: self.amountTextField)
    }
    
    private func addStyleToButtons() {
        self.closeButton.setElevation(ShadowElevation(rawValue: 0), for: .normal)
        
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        self.addButton.shapeGenerator = shapeGenerator
        self.saveButton.shapeGenerator = shapeGenerator
        self.deleteButton.shapeGenerator = shapeGenerator
        
        let positiveColorScheme = MDCSemanticColorScheme()
        positiveColorScheme.primaryColor = UIColor(red: 0.04, green: 0.69, blue: 0.00, alpha: 1.0)
        MDCContainedButtonColorThemer.applySemanticColorScheme(positiveColorScheme, to: self.addButton)
        MDCContainedButtonColorThemer.applySemanticColorScheme(positiveColorScheme, to: self.saveButton)
        
        let negativeColorScheme = MDCSemanticColorScheme()
        negativeColorScheme.primaryColor = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0)
        MDCContainedButtonColorThemer.applySemanticColorScheme(negativeColorScheme, to: self.deleteButton)
    }
    
    private func addDelegates() {
        self.brandTextField.delegate = self
        self.valueTextField.delegate = self
        self.amountTextField.delegate = self
    }
    
    private func populateBeer() {
        if (self.beer == nil) {
            self.editMode(isEditMode: false)
            return
        }
        
        self.editMode(isEditMode: true)
        
        self.brandTextField.text = self.beer.brand
        self.valueTextField.text = self.beerPresenter.formatValueToShow(value: self.beer.value)
        self.amountTextField.text = String(self.beer.amount)
    }
    
    private func editMode(isEditMode: Bool) {
        self.addButton.isHidden = isEditMode
        self.editStackView.isHidden = !isEditMode
    }
    
    private func getBeerArray() -> [String: Any]{
        var beer = [String: Any]()
        beer["amount"] = Int16(self.amountTextField.text ?? "")
        beer["brand"] = self.brandTextField.text
        beer["value"] = BeerPresenter().formatValue(value: self.valueTextField.text ?? "")
        
        var type: Int16 {
            return Int(self.amountTextField.text ?? "") ?? 0 >= 1000 ? 2 : 1
        }
        beer["type"] = type
        
        return beer
    }
    
    private func animateViewMoving (up: Bool, moveValue: CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        
        UIView.commitAnimations()
    }
    
    private func addBannerView() {
        self.bannerView.adUnitID = SettingsP().getAdMobBeerBannerID()
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
    }
    
    private func isValidBeer() -> Bool {
        let isValidAmount = Int16(self.amountTextField.text ?? "") ?? 0 > 0
        let isValidBrand = self.brandTextField.text?.count ?? 0 > 0
        let isValidValue = BeerPresenter().formatValue(value: self.valueTextField.text ?? "") > 0
        
        if (!isValidAmount) {
            self.amountController?.setErrorText("Digite um Tamanho", errorAccessibilityValue: nil)
        } else {
            self.amountController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        if (!isValidBrand) {
            self.brandController?.setErrorText("Digite um Nome", errorAccessibilityValue: nil)
        } else {
            self.brandController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        if (!isValidValue) {
            self.valueController?.setErrorText("Digite um Valor", errorAccessibilityValue: nil)
        } else {
            self.valueController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        return isValidAmount && isValidBrand && isValidValue
    }
}
