//
//  DonateCollectionViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

class DonateCollectionViewCell: UICollectionViewCell {
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
        
        descLabel.numberOfLines = 0
    }
    
    func setType(_ type: DonateType) {
        switch type {
        case .small:
            imageView.image = UIImage(named: "icons8-beer-can-100")
            descLabel.text = "Café\nR$ 4,90"
        case .medium:
            imageView.image = UIImage(named: "icons8-beer-bottle-100")
            descLabel.text = "Breja\nR$ 10,90"
        case .large:
            imageView.image = UIImage(named: "icons8-bottles-100")
            descLabel.text = "Churras\nR$ 16,90"
        }
    }
    
}
