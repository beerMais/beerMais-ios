//
//  DonateCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class DonateCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DonateCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = BeerColors.blackWhite
        
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDonate(_ donateProduct: DonateProduct) {
        switch donateProduct.type {
        case .small:
            imageView.image = BeerImage.iconBeerCan100
        case .medium:
            imageView.image = UIImage(named: "icons8-beer-bottle-100")
        case .large:
            imageView.image = UIImage(named: "icons8-bottles-100")
        }
        
        descLabel.text = "\(donateProduct.name)\n\(donateProduct.priceFormatted ?? "")"
    }
    
}

extension DonateCollectionViewCell: ViewProtocol {
    
    func buildViews() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
    func configViews() {
        addSubViews([
            imageView,
            descLabel
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            
            descLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}
