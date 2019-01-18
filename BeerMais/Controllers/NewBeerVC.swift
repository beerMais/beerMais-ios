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
    
    private var resumeBeers: ResumeBeersVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalView.layer.cornerRadius = 15
        
        self.addDelegates()
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
    
    private func addDelegates() {
        self.brandTextField.delegate = self
        self.valueTextField.delegate = self
        self.amountTextField.delegate = self
    }
}
