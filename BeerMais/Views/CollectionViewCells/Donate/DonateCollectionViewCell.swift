//
//  DonateCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class DonateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    static let reuseIdentifier = "DonateCollectionViewCell"
    
    class func dequeueReusableCell(from collectionView: UICollectionView,
                                   for indexPath: IndexPath) -> DonateCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: DonateCollectionViewCell.reuseIdentifier,
                                                  for: indexPath) as! DonateCollectionViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        
        descLabel.numberOfLines = 0
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
