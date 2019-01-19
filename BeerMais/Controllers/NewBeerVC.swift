//
//  NewBeerVC.swift
//  BeerMais
//
//  Created by Jose Neves on 26/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit

class NewBeerVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editStackView: UIStackView!
    
    private var resumeBeers: ResumeBeersVCDelegate!
    private var beer: Beer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalView.layer.cornerRadius = 15
        
        self.addDelegates()
        self.populateBeer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        var beer = [String: Any]()
        beer["amount"] = Int16(self.amountTextField.text ?? "")
        beer["brand"] = self.brandTextField.text
        beer["value"] = BeerPresenter().formatValue(value: self.valueTextField.text ?? "")
        beer["type"] = Int16(1)
        _ = BeerPresenter().create(data: beer)
        
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
}
