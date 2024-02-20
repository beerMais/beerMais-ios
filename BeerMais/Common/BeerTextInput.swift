//
//  BeerTextInput.swift
//  BeerMais
//
//  Created by José Neves on 20/02/24.
//  Copyright © 2024 joseneves. All rights reserved.
//

import Foundation
import UIKit

protocol BeerTextInputProtocol {
    func showError(message: String?)
}

final class BeerTextInput: UIView, BeerTextInputProtocol {
    
    // MARK: - Public properties
    
    private(set) var textField: BeerTextField
    
    // MARK: - Private properties
    
    private lazy var placeholderLabel: UILabel = {
        let view = UILabel()

        view.textColor = .label
        view.font = .systemFont(ofSize: 12)
        view.text = placeholder
        view.layer.backgroundColor = placeholderBackgroundColor.cgColor
        view.backgroundColor = placeholderBackgroundColor
        view.clipsToBounds = true
        view.textAlignment = .center
        view.alpha = 0
        
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let view = UILabel()

        view.font = .systemFont(ofSize: 11)
        
        if helperText != nil {
            view.textColor = .gray
            view.text = helperText
        } else {
            view.textColor = .red
            view.alpha = 0
        }
        
        return view
    }()
    
    // MARK: - Injected properties
    
    let placeholder: String?
    let placeholderBackgroundColor: UIColor
    let helperText: String?
    
    // MARK: - Initialization
    
    init(
        placeholder: String? = nil,
        placeholderBackgroundColor: UIColor = .systemBackground,
        helperText: String? = nil
    ) {
        self.textField = BeerTextField()
        self.placeholder = placeholder
        self.placeholderBackgroundColor = placeholderBackgroundColor
        self.helperText = helperText
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textChanged() {
        if textField.text.orEmpty.isEmpty {
            hideplaceholderLabel()
        } else {
            showplaceholderLabel()
        }
    }
    
    private func hideplaceholderLabel() {
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.alpha = 0
        }
    }
    
    private func showplaceholderLabel() {
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.alpha = 1
        }
    }
    
    // MARK: - BeerTextInputProtocol
    
    func showError(message: String?) {
        
        guard let message, !message.isEmpty else {
            UIView.animate(withDuration: 0.2) {
                self.textField.layer.borderColor = UIColor.lightGray.cgColor
                
                if self.helperText != nil {
                    self.errorLabel.textColor = .gray
                    self.errorLabel.text = self.helperText
                } else {
                    self.errorLabel.alpha = 0
                }
            }
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.textField.layer.borderColor = UIColor.red.cgColor
            
            self.errorLabel.textColor = .red
            self.errorLabel.text = message
            self.errorLabel.alpha = 1
        }
    }
}

extension BeerTextInput: ViewProtocol {
    
    func buildViews() {
        backgroundColor = .clear
        
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 14)
        textField.backgroundColor = .clear
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    func configViews() {
        addSubViews([
            textField,
            placeholderLabel,
            errorLabel
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.centerYAnchor.constraint(equalTo: textField.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10),
            placeholderLabel.widthAnchor.constraint(
                equalToConstant: placeholderLabel.intrinsicContentSize.width + 4
            ),
            
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: -2),
            errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ])
    }
}
