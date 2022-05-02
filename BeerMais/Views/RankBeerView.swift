//
//  RankBeerView.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol RankBeerViewProtocol {
    func setBorderStyle(isHighlighted: Bool)
    func setDefaultData()
    func setBeerData(with beer: Beer, economy: String)
}

final class RankBeerView: UIView, RankBeerViewProtocol {
    
    lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "brand".localized
        
        return view
    }()
    
    lazy var beerImageView: UIImageView = {
        let view = UIImageView()
        view.image = BeerImage.iconBeerCan100
        view.tintColor = BeerColors.blackWhite
        
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 16)
        view.text = "350ml"
        
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "R$ 0,00"
        
        return view
    }()
    
    lazy var economyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "saving".localized
        
        return view
    }()
    
    lazy var economyValueLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        view.text = "R$ 0,00/L"
        view.textColor = BeerColors.economyBorder
        
        return view
    }()
    
    lazy var disclaimerLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 10)
        view.text = "disclaimer".localized
        view.textColor = UIColor.lightGray
        
        return view
    }()
    
    func setBorderStyle(isHighlighted: Bool) {
        if (isHighlighted) {
            layer.borderColor = BeerColors.economyBorder.cgColor
            layer.borderWidth = 2.0
            backgroundColor = BeerColors.economyBackground
            
            return
        }
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.tertiarySystemBackground
        } else {
            backgroundColor = UIColor.white
        }
    }
    
    func setDefaultData() {
        brandLabel.text = "brand".localized
        beerImageView.image = BeerImage.iconBeerCan100
        amountLabel.text = "350ml"
        valueLabel.text = "RS 0,00"
        economyValueLabel.text = "R$ 0,00/L"
    }
    
    func setBeerData(with beer: Beer, economy: String) {
        brandLabel.text = beer.brand
        
        var amountText = "\(beer.amount)ml"
        
        if (beer.amount >= 1000) {
            amountText = "1 L"
            
            if (beer.amount >= 1010) {
                var amountString = String(format: "%.2f", Float(beer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            }
        }
        amountLabel.text = amountText
        
        if beer.type == 2 {
            beerImageView.image = BeerImage.iconBeerBottle100
        } else {
            beerImageView.image = BeerImage.iconBeerCan100
        }
        
        let valueString = BeerP().formatValueToShow(value: beer.value)
        valueLabel.text = "R$ \(valueString)"
        economyValueLabel.text = "R$ \(economy)/L"
    }
    
}

// MARK: - ViewProtocol

extension RankBeerView: ViewProtocol {
    func buildViews() {
        layer.cornerRadius = 15
        
        setBorderStyle(isHighlighted: false)
        setDefaultData()
    }
    
    func configViews() {
        addSubViews([brandLabel,
                     beerImageView,
                     amountLabel,
                     valueLabel,
                     economyLabel,
                     economyValueLabel,
                     disclaimerLabel])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            brandLabel.heightAnchor.constraint(equalToConstant: 21),
            brandLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            brandLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            beerImageView.heightAnchor.constraint(equalToConstant: 50),
            beerImageView.widthAnchor.constraint(equalToConstant: 50),
            beerImageView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 16),
            beerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            amountLabel.heightAnchor.constraint(equalToConstant: 21),
            amountLabel.widthAnchor.constraint(equalToConstant: 50),
            amountLabel.topAnchor.constraint(equalTo: beerImageView.bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            valueLabel.heightAnchor.constraint(equalToConstant: 25),
            valueLabel.widthAnchor.constraint(equalToConstant: 100),
            valueLabel.leadingAnchor.constraint(equalTo: beerImageView.trailingAnchor, constant: 16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -29),
            
            economyLabel.heightAnchor.constraint(equalToConstant: 25),
            economyLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 13),
            economyLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            economyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            economyValueLabel.heightAnchor.constraint(equalToConstant: 25),
            economyValueLabel.topAnchor.constraint(equalTo: economyLabel.bottomAnchor, constant: 4),
            economyValueLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            economyValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            disclaimerLabel.heightAnchor.constraint(equalToConstant: 14),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            disclaimerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])
    }
    
}
