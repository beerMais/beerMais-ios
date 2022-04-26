//
//  ViewProtocol.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

protocol ViewProtocol {
    func buildViews()
    func configViews()
    func setupConstraints()
    
    func setupViews()
}

extension ViewProtocol {
    func setupViews() {
        self.configViews()
        self.buildViews()
        self.setupConstraints()
    }
}
