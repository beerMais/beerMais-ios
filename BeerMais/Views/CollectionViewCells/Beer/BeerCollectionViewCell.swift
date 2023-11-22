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
    
    private var beer: Beer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
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
        
        let valueString = BeerP().formatValueToShow(value: beer.value)
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
        
        beerImageView.image = UIImage(named: imageName)
    }
    
    func setBackgroudColor(color: UIColor) {
        cellView.backgroundColor = color
    }
    
    func setCounter(counter: Int) {
        counterLabel.text = String(counter)
    }
    
    private func calculatePerLiter() {
        guard 
            let beer,
            beer.amount != 0 && beer.value != 0
        else { return }
        
        let perLiter = BeerFacade().getValuePerML(beer: beer) * 1000
        self.perLiterLabel.text = "R$ \(BeerP().formatValueToShow(value: perLiter))/L"
    }
}
