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

class NewBeerVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: MDCButton!
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var closeButton: MDCButton!
    @IBOutlet weak var deleteButton: MDCButton!
    @IBOutlet weak var saveButton: MDCButton!
    
    private var resumeBeers: ResumeBeersVCDelegate!
    private var beer: Beer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalView.layer.cornerRadius = 15
        self.addStyleToButton()
        
        self.addDelegates()
        self.populateBeer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        _ = BeerPresenter().create(data: self.getBeerArray())
        
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if (self.beer == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        BeerPresenter().delete(beer: self.beer)
        self.resumeBeers.reloadBeers()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        if (self.beer == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        BeerPresenter().edit(beer: self.beer, data: self.getBeerArray())
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
    
    private func addStyleToButton() {
        self.addButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.saveButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.deleteButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        self.closeButton.setElevation(ShadowElevation(rawValue: 6), for: .normal)
        
        let shapeGenerator = MDCCurvedRectShapeGenerator()
        shapeGenerator.cornerSize = CGSize(width: 6, height: 6)
        self.addButton.shapeGenerator = shapeGenerator
        self.saveButton.shapeGenerator = shapeGenerator
        self.deleteButton.shapeGenerator = shapeGenerator
        self.closeButton.shapeGenerator = shapeGenerator
        
        let positiveColorScheme = MDCSemanticColorScheme()
        positiveColorScheme.primaryColor = UIColor(red:0.04, green:0.69, blue:0.00, alpha:1.0)
        MDCContainedButtonColorThemer.applySemanticColorScheme(positiveColorScheme, to: self.addButton)
        MDCContainedButtonColorThemer.applySemanticColorScheme(positiveColorScheme, to: self.saveButton)
        
        let negativeColorScheme = MDCSemanticColorScheme()
        negativeColorScheme.primaryColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
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
        self.valueTextField.text = String(self.beer.value)
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
