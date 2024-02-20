//
//  BeerDetailView.swift
//  BeerMais
//
//  Created by Jose Neves on 26/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import BasicsKit

protocol BeerDetailViewProtocol {
    func setBrand(with brand: String)
    func setPrice(with price: String)
    func setSize(with size: String)
    func setSegmentIndex(_ index: Int)
    func isEditMode(_ isEditMode: Bool)
    func setIsValidAmount(_ isValidAmount: Bool)
    func setIsValidBrand(_ isValidBrand: Bool)
    func setIsValidValue(_ isValidValue: Bool)
    func deleteSucess()
    func editSucess()
    func createSucess()
}

final class BeerDetailView: UIView {
    
    lazy var brandTextField: BeerTextInput = {
        let view = BeerTextInput(
            placeholder: "brand".localized,
            placeholderBackgroundColor: .tertiarySystemBackground
        )
        view.textField.delegate = self
        view.textField.addTarget(self, action: #selector(brandValueChanged(_:)), for: .editingChanged)
        
        return view
    }()
    
    lazy var priceTextField: BeerTextInput = {
        let view = BeerTextInput(
            placeholder: "price".localized,
            placeholderBackgroundColor: .tertiarySystemBackground
        )
        view.textField.delegate = self
        view.textField.keyboardType = .numberPad
        view.textField.addTarget(self, action: #selector(priceValueChanged(_:)), for: .editingChanged)
        
        return view
    }()
    
    lazy var sizeTextField: BeerTextInput = {
        let view = BeerTextInput(
            placeholder: "size".localized,
            placeholderBackgroundColor: .tertiarySystemBackground,
            helperText: "sizeDesc".localized
        )
        view.textField.delegate = self
        view.textField.keyboardType = .numberPad
        view.textField.addTarget(self, action: #selector(amountValueChanged(_:)), for: .editingChanged)
        
        return view
    }()
    
    lazy var amountSegment: UISegmentedControl = {
        let view = UISegmentedControl(items: ["269ml", "350ml", "473ml", "1L"])
        view.addTarget(self, action: #selector(amountSegmentChanged(_:)), for: .valueChanged)
        
        return view
    }()
    
    lazy var disclaimerLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.numberOfLines = 0
        view.text = "detailsHelpText".localized
        
        return view
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.distribution = .fillEqually
        
        return view
    }()
    
    lazy var deleteButton: BeerButton = {
        let view = BeerButton.build(style: .negative)
        view.setTitle("delete".localized, for: .normal)
        view.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    lazy var saveButton: BeerButton = {
        let view = BeerButton.build(style: .positive)
        view.setTitle("save".localized, for: .normal)
        view.addTarget(self, action: #selector(saveAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    lazy var addButton: BeerButton = {
        let view = BeerButton.build(style: .positive)
        view.setTitle("add".localized, for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    var presenter: BeerDetailPresenterProtocol?
    var delegate: DetailsViewControllerProtocol?
    
    @objc func brandValueChanged(_ sender: Any) {
        presenter?.brandValueChanged(value: brandTextField.textField.text.orEmpty)
    }
    
    @objc func priceValueChanged(_ sender: Any) {
        presenter?.priceValueChanged(value: priceTextField.textField.text.orEmpty)
    }
    
    @objc func amountValueChanged(_ sender: Any) {
        presenter?.amountValueChanged(value: sizeTextField.textField.text.orEmpty)
    }
    
    @objc func amountSegmentChanged(_ sender: UISegmentedControl) {
        presenter?.amountSegmentChanged(index: sender.selectedSegmentIndex)
    }
    
    @objc func deleteAction(_ sender: Any) {
        presenter?.deleteBeer()
    }
    
    @objc func saveAction(_ sender: Any) {
        presenter?.editBeer()
    }
    
    @objc func addAction(_ sender: Any) {
        presenter?.createBeer()
    }
    
}

extension BeerDetailView: ViewProtocol {
    
    func buildViews() {
        backgroundColor = .tertiarySystemBackground
        
        layer.cornerRadius = 10
    }
    
    func configViews() {
        buttonsStackView.addArrangedSubviews([deleteButton,
                                              saveButton])
        
        addSubViews([
            brandTextField,
            priceTextField,
            sizeTextField,
            amountSegment,
            disclaimerLabel,
            buttonsStackView,
            addButton
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            brandTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            brandTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            brandTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            priceTextField.widthAnchor.constraint(equalToConstant: 126),
            priceTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor),
            priceTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            sizeTextField.widthAnchor.constraint(equalToConstant: 126),
            sizeTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor),
            sizeTextField.leadingAnchor.constraint(equalTo: priceTextField.trailingAnchor, constant: 16),
            sizeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            amountSegment.heightAnchor.constraint(equalToConstant: 30),
            amountSegment.topAnchor.constraint(equalTo: sizeTextField.bottomAnchor, constant: 4),
            amountSegment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountSegment.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            disclaimerLabel.topAnchor.constraint(equalTo: amountSegment.bottomAnchor, constant: 8),
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 35),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addButton.heightAnchor.constraint(equalToConstant: 35),
            addButton.widthAnchor.constraint(equalToConstant: 110),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

extension BeerDetailView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.animateViewMoving(up: true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.animateViewMoving(up: false, moveValue: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BeerDetailView: BeerDetailViewProtocol {
    
    func setBrand(with brand: String) {
        brandTextField.setText(brand)
    }
    
    func setPrice(with price: String) {
        priceTextField.setText(price)
    }
    
    func setSize(with size: String) {
        sizeTextField.setText(size)
    }
    
    func setSegmentIndex(_ index: Int) {
        amountSegment.selectedSegmentIndex = index
    }
    
    func isEditMode(_ isEditMode: Bool) {
        addButton.isHidden = isEditMode
        buttonsStackView.isHidden = !isEditMode
    }
    
    func setIsValidAmount(_ isValidAmount: Bool) {
        var errorText: String?
        
        if !isValidAmount {
            errorText = "addSize".localized
        }
        
        sizeTextField.showError(message: errorText)
    }
    
    func setIsValidBrand(_ isValidBrand: Bool) {
        var errorText: String?
        
        if !isValidBrand {
            errorText = "addBrand".localized
        }
        
        brandTextField.showError(message: errorText)
    }
    
    func setIsValidValue(_ isValidValue: Bool) {
        var errorText: String?
        
        if !isValidValue {
            errorText = "addPrice".localized
        }
        
        priceTextField.showError(message: errorText)
    }
    
    func deleteSucess() {
        delegate?.close()
    }
    
    func editSucess() {
        delegate?.close()
    }
    
    func createSucess() {
        delegate?.close()
    }
    
}
