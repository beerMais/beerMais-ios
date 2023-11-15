//
//  BeerCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 25/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit

final class BeerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var perLiterLabel: UILabel!
    
    private var amount: Int16 = 0
    private var value: Float = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func setAmount(amount: Int16) {
        var amountText = "\(amount)ml"
        
        if (amount >= 1000) {
            amountText = "1 L"
            
            if (amount >= 1010) {
                var amountString = String(format: "%.2f", Float(amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            }
        }
        
        self.amountLabel.text = amountText
        
        self.amount = amount
        self.calculatePerLiter()
    }
    
    func setBrand(brand: String) {
        self.brandLabel.text = brand
    }
    
    func setValue(value: Float) {
        let valueString = BeerP().formatValueToShow(value: value)
        self.valueLabel.text = "R$ \(valueString)"
        
        self.value = value
        self.calculatePerLiter()
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
    
    func setBackgroudColor(color: UIColor) {
        self.cellView.backgroundColor = color
    }
    
    func setCounter(counter: Int) {
        self.counterLabel.text = String(counter)
    }
    
    private func calculatePerLiter() {
        if amount == 0 && value == 0 {
            return
        }
        
        let beerP = BeerP()
        let perLiter = beerP.getValuePerML(value: value, amount: amount) * 1000
        self.perLiterLabel.text = "R$ \(beerP.formatValueToShow(value: perLiter))/L"
    }
}
