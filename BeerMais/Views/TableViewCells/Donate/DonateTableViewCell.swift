//
//  DonateTableViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

class DonateTableViewCell: UITableViewCell {
    @IBOutlet weak var donateCollectionView: UICollectionView!
    
    static let reuseIdentifier = "DonateTableViewCell"
    
    var count = 3
    
    class func dequeueReusableCell(from tableView: UITableView, maxWidth: CGFloat) -> DonateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DonateTableViewCell.reuseIdentifier) as! DonateTableViewCell
        cell.teste(with: maxWidth)
        return cell
    }
    
    override func awakeFromNib() {
        donateCollectionView.register(UINib(nibName: "DonateCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: DonateCollectionViewCell.reuseIdentifier)
    }
    
    func teste(with maxWidth: CGFloat) {
        let margin: CGFloat = 5
        donateCollectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        donateCollectionView.delegate = self
        donateCollectionView.dataSource = self
        
        let collectionViewFLowLayout = UICollectionViewFlowLayout()

        let totalWidth = Int(maxWidth - (margin * CGFloat(count + 1)))
        collectionViewFLowLayout.itemSize = CGSize(width: totalWidth / count,
                                                   height: 190)
        collectionViewFLowLayout.minimumLineSpacing = 0
        collectionViewFLowLayout.minimumInteritemSpacing = 0
        donateCollectionView.collectionViewLayout = collectionViewFLowLayout
    }

}

extension DonateTableViewCell: UICollectionViewDelegate {
    
}

extension DonateTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DonateCollectionViewCell.dequeueReusableCell(from: collectionView, for: indexPath)
        
        if let donateType = DonateType(rawValue: indexPath.row) {
            cell.setType(donateType)
        }
        
        return cell
    }
    
}
