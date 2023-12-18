//
//  BeerCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 25/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit

final class BeerCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "BeerCollectionCell"
    
    lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var beerImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = BeerColors.blackWhite
        
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20)
        view.textAlignment = .center
        
        return view
    }()
    
    lazy var perLiterLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .center
        view.textColor = .secondaryLabel
        
        return view
    }()
    
    lazy var counterLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 10)
        view.textColor = .lightGray
        
        return view
    }()
    
    private var beer: Beer?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBeer(beer: Beer) {
        self.beer = beer
        
        setAmount()
        setBrand()
        setValue()
        setType()
    }
    
    func setAmount() {
        guard let beer else { return }
        
        var amountText = "\(beer.amount)ml"
        
        if (beer.amount >= 1000) {
            amountText = "1 L"
            
            if (beer.amount >= 1010) {
                var amountString = String(format: "%.2f", Float(beer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            }
        }
        
        self.amountLabel.text = amountText
        
        self.calculatePerLiter()
    }
    
    func setBrand() {
        guard let beer else { return }
        
        brandLabel.text = beer.brand
    }
    
    func setValue() {
        guard let beer else { return }
        
        let valueString = BeerWorker().formatBeerValueToShow(value: beer.value)
        self.valueLabel.text = "R$ \(valueString)"
        
        self.calculatePerLiter()
    }
    
    func setType() {
        guard let beer else { return }
        
        var imageName = ""
        switch beer.type {
        case 1:
            imageName = "icons8-beer-can-100"
        case 2:
            imageName = "icons8-beer-bottle-100"
        default:
            imageName = "icons8-beer-can-100"
        }
        
        beerImageView.image = UIImage(named: imageName, in: .beerMais, with: nil)
    }
    
    func setBackgroudColor(color: UIColor) {
        backgroundColor = color
    }
    
    func setCounter(counter: Int) {
        counterLabel.text = String(counter)
    }
    
    private func calculatePerLiter() {
        guard 
            let beer,
            beer.amount != 0 && beer.value != 0
        else { return }
        
        let perLiter = BeerWorker().getValuePerML(beer: beer) * 1000
        self.perLiterLabel.text = "R$ \(BeerWorker().formatBeerValueToShow(value: perLiter))/L"
    }
}

extension BeerCollectionViewCell: ViewProtocol {
    
    func buildViews() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
    func configViews() {
        addSubViews([
            brandLabel,
            beerImageView,
            amountLabel,
            valueLabel,
            perLiterLabel,
            counterLabel
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            brandLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            brandLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            brandLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            brandLabel.heightAnchor.constraint(equalToConstant: 21),
            
            beerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            beerImageView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 8),
            beerImageView.heightAnchor.constraint(equalToConstant: 50),
            beerImageView.widthAnchor.constraint(equalToConstant: 50),
            
            amountLabel.leadingAnchor.constraint(equalTo: beerImageView.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: beerImageView.trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: beerImageView.bottomAnchor),
            amountLabel.heightAnchor.constraint(equalToConstant: 21),
            
            valueLabel.leadingAnchor.constraint(equalTo: beerImageView.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            valueLabel.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: 23),
            valueLabel.heightAnchor.constraint(equalToConstant: 25),
            
            perLiterLabel.leadingAnchor.constraint(equalTo: beerImageView.trailingAnchor, constant: 8),
            perLiterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            perLiterLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            perLiterLabel.heightAnchor.constraint(equalToConstant: 12),
            
            counterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            counterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
        ])
    }
}
