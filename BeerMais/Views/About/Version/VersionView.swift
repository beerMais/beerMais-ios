//
//  VersionView.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class VersionView: UIView {
    
    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        
        return view
    }()
    
    lazy var versionLabel: UILabel = {
        let view = UILabel()
        view.text = "appVersion".localized
        
        return view
    }()
    
    lazy var versionNumberLabel: UILabel = {
        let view = UILabel()
        view.text = VersionP.getAppVersion()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VersionView: ViewProtocol {
    func buildViews() {
        containerStackView.addArrangedSubviews([
            versionLabel,
            versionNumberLabel
        ])
    }
    
    func configViews() {
        addSubViews([
            containerStackView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}
