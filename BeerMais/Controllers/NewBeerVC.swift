//
//  NewBeerVC.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit
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
    
    private var resumeBeers: ResumeBeersVCDelegate!
    private var beer: Beer!
    private var beerPresenter: BeerPresenter!
    
    var brandController: MDCTextInputControllerOutlined?
    var valueController: MDCTextInputControllerOutlined?
    var amountController: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.beerPresenter.edit(beer: self.beer, data: self.getBeerArray())
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        self.addButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.saveButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.deleteButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
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
        beer["type"] = Int16(1)
        
        return beer
    }
}
