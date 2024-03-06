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
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        
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
        view.textColor = .secondaryLabel
        
        return view
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.distribution = .fillEqually
        
        return view
    }()
    
    lazy var negativeButton: BeerButton = {
        let view = BeerButton(
            style: .neutral,
            title: "no".localized
        )
        view.addTarget(self, action: #selector(negativeAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    lazy var positiveButton: BeerButton = {
        let view = BeerButton(
            style: .positive,
            title: "yes".localized
        )
        view.addTarget(self, action: #selector(positiveAction(_:)), for: .touchUpInside)
        
        return view
    }()
    
    lazy var adBannerView: BeerAdView = {
        let view = BeerAdView.build(with: self)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        let touch = touches.first
        guard let location = touch?.location(in: view) else { return }
        
        if !container.frame.contains(location) {
            close()
        }
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
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        container.layer.cornerRadius = 10
    }
    
    func configViews() {
        view.addSubViews([
            container
        ])
        
        buttonsStackView.addArrangedSubviews([negativeButton,
                                              positiveButton])
        
        container.addSubViews([
            titleLabel,
            bodyLabel,
            buttonsStackView,
            adBannerView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 300),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -16),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -16),
            
            buttonsStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant:  -16),
            
            adBannerView.heightAnchor.constraint(equalToConstant: 100),
            adBannerView.widthAnchor.constraint(equalToConstant: 320),
            adBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adBannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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

