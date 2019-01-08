//
//  BeerCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 25/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setAmount(amount: Int16) {
        self.amountLabel.text = "\(amount)ml"
    }
    
    func setBrand(brand: String) {
        self.brandLabel.text = brand.capitalized
    }
    
    func setValue(value: Float) {
        self.valueLabel.text = "R$ \(value)"
    }
    
    func setType(type: Int16) {
        var imageName = ""
        switch type {
        case 1:
            imageName = "icons8-beer-can-100"
        case 2:
            imageName = "icons8-beer-bottle-100"
        default:
            imageName = "icons8-beer-can-100"
        }
        
        self.beerImageView.image = UIImage(named: imageName)
    }
}
