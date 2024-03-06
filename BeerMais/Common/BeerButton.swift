//
//  BeerButton.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import BasicsKit

final class BeerButton: UIButton {
    
    // MARK: - ButtonStyle
    
    enum ButtonStyle {
        case positive
        case negative
        case neutral
    }
    
    // MARK: - Private Properties
    
    lazy var buttonColor: UIColor = {
        switch style {
        case .positive:
            return BeerColors.buttonPositive
        case .negative:
            return BeerColors.buttonNegative
        case .neutral:
            return .gray
        }
    }()
    
    
    // MARK: - Injected Properties
    
    var style: ButtonStyle
    var title: String?
    
    // MARK: - Initialization
    
    init(
        style: ButtonStyle = .neutral,
        title: String? = nil
    ) {
        self.style = style
        self.title = title
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BeerButton: ViewProtocol {
    
    func buildViews() {
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.bordered()
            configuration?.baseBackgroundColor = buttonColor
            configuration?.attributedTitle = AttributedString(
                title.orEmpty,
                attributes: .init([
                    .font: UIFont.systemFont(ofSize: 16, weight: .medium)
                ])
            )
        } else {
            backgroundColor = buttonColor
            layer.cornerRadius = 8
            setTitle(title, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        }
        
        tintColor = .white
    }
    
    func configViews() {}
    
    func setupConstraints() {}
}
