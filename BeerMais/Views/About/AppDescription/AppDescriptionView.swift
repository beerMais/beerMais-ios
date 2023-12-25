//
//  AppDescriptionView.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class AppDescriptionView: UIView {
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .justified
        view.tintColor = BeerColors.primary
        view.isUserInteractionEnabled = true
        view.isEditable = false
        view.isScrollEnabled = false
        view.dataDetectorTypes = .link
        view.text = """
A ideia desse app nasceu quando 3 amigos estavam fazendo as contas para decidir qual cerveja compensaria comprar para um churrasco.

Não tendo um foco apenas em cerveja, o Beer Mais pode ser usado para calcular o melhor custo-beneficio entre quaisquer bebidas.

A área em verde destaca a bebida de maior custo-beneficio e ordena a lista utilizando do mesmo critério.

Ícones:
https://icons8.com
https://www.flaticon.com
"""
        
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

extension AppDescriptionView: ViewProtocol {
    func buildViews() {
        
    }
    
    func configViews() {
        addSubViews([
            textView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
