//
//  AlertViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 28/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol AlertViewControllerProtocol {
    func setTitle(title: String)
    func setDescription(description: String)
    func setNegativeButtonTitle(title: String)
    func setPositiveButtonTitle(title: String)
    func close()
}

final class AlertViewController: UIViewController {
    
    var interactor: AlertInteractorProtocol?
    
    lazy var contrainer: UIView = {
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .tertiarySystemBackground
        } else {
            view.backgroundColor = .white
        }
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return view
    }()
    
    lazy var bodyLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.numberOfLines = 0
        
        if #available(iOS 13.0, *) {
            view.textColor = .secondaryLabel
        } else {
            view.textColor = .gray
        }
        
        return view
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.distribution = .fillEqually
        
        return view
    }()
    
    lazy var negativeButton: BeerButton = {
        let view = BeerButton.build(style: .neutral)
        view.setTitle("Não", for: .normal)
        view.addTarget(self, action: #selector(negativeAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    lazy var positiveButton: BeerButton = {
        let view = BeerButton.build(style: .positive)
        view.setTitle("Sim", for: .normal)
        view.addTarget(self, action: #selector(positiveAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc func negativeAction(_ sender: Any) {
        interactor?.negativeAction()
    }
    
    @objc func positiveAction(_ sender: Any) {
        interactor?.positiveAction()
    }
    
}

extension AlertViewController: ViewProtocol {
    func buildViews() {
        
    }
    
    func configViews() {
        view.addSubViews([
            contrainer
        ])
        
        buttonsStackView.addArrangedSubviews([negativeButton,
                                              positiveButton])
        
        contrainer.addSubViews([
            titleLabel,
            bodyLabel,
            buttonsStackView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contrainer.widthAnchor.constraint(equalToConstant: 300),
            contrainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contrainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.topAnchor.constraint(equalTo: contrainer.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contrainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contrainer.trailingAnchor, constant:  -16),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: contrainer.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: contrainer.trailingAnchor, constant:  -16),
            
            buttonsStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: contrainer.bottomAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contrainer.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: contrainer.trailingAnchor, constant:  -16),
        ])
    }
    
}

extension AlertViewController: AlertViewControllerProtocol {
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setDescription(description: String) {
        bodyLabel.text = description
    }
    
    func setNegativeButtonTitle(title: String) {
        negativeButton.setTitle(title, for: .normal)
    }
    
    func setPositiveButtonTitle(title: String) {
        positiveButton.setTitle(title, for: .normal)
    }
    
    func close() {
        dismiss(animated: true)
    }
}

