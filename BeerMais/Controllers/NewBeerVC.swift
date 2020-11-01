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


class NewBeerVC: UIViewController {
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
    @IBOutlet weak var amountSegment: UISegmentedControl!
    
    private var resumeBeers: ResumeBeersVCDelegate!
    private var beer: Beer!
    private var beerP: BeerP!
    
    private var amountValues: [Int: String] = [
        0: "269",
        1: "350",
        2: "473",
        3: "1000"
    ]
    
    private var brandController: MDCTextInputControllerOutlined?
    private var valueController: MDCTextInputControllerOutlined?
    private var amountController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBannerView()
        
        self.beerP = BeerP()
        
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
        _ = self.beerP.create(data: self.getBeerArray())
        
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if (self.beer == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.beerP.delete(beer: self.beer)
        
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
        
        self.beerP.edit(beer: self.beer, data: self.getBeerArray())
        
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func amountSegmentChanged(_ sender: UISegmentedControl) {
        amountTextField.text = amountValues[sender.selectedSegmentIndex]
    }
    
    @IBAction func amountEditingDidBegin(_ sender: Any) {
        parseAmountToFillSegment()
    }
    
    @IBAction func amountEditingChanged(_ sender: Any) {
        parseAmountToFillSegment()
    }
    
    @IBAction func valueEditingChanged(_ sender: Any) {
        setValue(NSNumber(value: BeerP.getValueFromString(value: valueTextField.text ?? "")))
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
        self.amountController?.helperText = "sizeDesc".localized
        
        if #available(iOS 13.0, *) {
            self.addDarkModeToFields()
        }
    }
    
    private func addDarkModeToFields() {
        self.brandController?.inlinePlaceholderColor =  UIColor(named: "black-white")
        self.brandController?.floatingPlaceholderNormalColor =  UIColor(named: "black-white")
        self.brandController?.leadingUnderlineLabelTextColor =  UIColor(named: "black-white")
        self.brandController?.textInput?.textColor =  UIColor(named: "black-white")
        
        self.valueController?.inlinePlaceholderColor =  UIColor(named: "black-white")
        self.valueController?.floatingPlaceholderNormalColor =  UIColor(named: "black-white")
        self.valueController?.leadingUnderlineLabelTextColor =  UIColor(named: "black-white")
        self.valueController?.textInput?.textColor =  UIColor(named: "black-white")
        
        self.amountController?.inlinePlaceholderColor =  UIColor(named: "black-white")
        self.amountController?.floatingPlaceholderNormalColor =  UIColor(named: "black-white")
        self.amountController?.leadingUnderlineLabelTextColor =  UIColor(named: "black-white")
        self.amountController?.textInput?.textColor =  UIColor(named: "black-white")
    }
    
    private func addStyleToButtons() {
        self.closeButton.setElevation(ShadowElevation(0), for: .normal)
        
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        self.addButton.shapeGenerator = shapeGenerator
        self.saveButton.shapeGenerator = shapeGenerator
        self.deleteButton.shapeGenerator = shapeGenerator
        
        let positiveColorScheme = MDCSemanticColorScheme()
        positiveColorScheme.primaryColor = UIColor(red: 0.04, green: 0.69, blue: 0.00, alpha: 1.0)
        
        let positiveCS = MDCContainerScheme()
        positiveCS.colorScheme = positiveColorScheme
        self.addButton.applyContainedTheme(withScheme: positiveCS)
        self.saveButton.applyContainedTheme(withScheme: positiveCS)
        
        let negativeColorScheme = MDCSemanticColorScheme()
        negativeColorScheme.primaryColor = UIColor(red: 0.96, green: 0.26, blue: 0.21, alpha: 1.0)
        
        let negativeCS = MDCContainerScheme()
        negativeCS.colorScheme = negativeColorScheme
        self.deleteButton.applyContainedTheme(withScheme: negativeCS)
        
        self.addButton.setElevation(ShadowElevation(1), for: .normal)
        self.saveButton.setElevation(ShadowElevation(1), for: .normal)
        self.deleteButton.setElevation(ShadowElevation(1), for: .normal)
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
        setValue(NSNumber(value: beer.value))
        self.amountTextField.text = String(self.beer.amount)
        parseAmountToFillSegment()
    }
    
    private func editMode(isEditMode: Bool) {
        self.addButton.isHidden = isEditMode
        self.editStackView.isHidden = !isEditMode
    }
    
    private func getBeerArray() -> [String: Any]{
        var beer = [String: Any]()
        beer["amount"] = Int16(self.amountTextField.text ?? "")
        beer["brand"] = self.brandTextField.text
        beer["value"] = BeerP.getValueFromString(value: valueTextField.text ?? "")
        
        var type: Int16 {
            return Int(self.amountTextField.text ?? "") ?? 0 >= 1000 ? 2 : 1
        }
        beer["type"] = type
        
        return beer
    }
    
    private func animateViewMoving (up: Bool, moveValue: CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
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
        let isValidValue = BeerP.getValueFromString(value: valueTextField.text ?? "") > 0
        
        if (!isValidAmount) {
            self.amountController?.setErrorText("addSize".localized, errorAccessibilityValue: nil)
        } else {
            self.amountController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        if (!isValidBrand) {
            self.brandController?.setErrorText("addBrand".localized, errorAccessibilityValue: nil)
        } else {
            self.brandController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        if (!isValidValue) {
            self.valueController?.setErrorText("addPrice".localized, errorAccessibilityValue: nil)
        } else {
            self.valueController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        return isValidAmount && isValidBrand && isValidValue
    }
    
    private func parseAmountToFillSegment() {
        let amountValue = amountValues.filter {
            $0.value == amountTextField.text
        }
        
        if amountValue.count > 0 {
            amountSegment.selectedSegmentIndex = amountValue.first?.key ?? -1
        } else {
            amountSegment.selectedSegmentIndex = -1
        }
    }
    
    private func setValue(_ value: NSNumber) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.decimalSeparator = ","
        formatter.currencySymbol = "R$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        if value.intValue == 0  {
            valueTextField.text = ""
        }

        valueTextField.text = formatter.string(from: value)!
    }
}

extension NewBeerVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateViewMoving(up: false, moveValue: 100)
        parseAmountToFillSegment()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
