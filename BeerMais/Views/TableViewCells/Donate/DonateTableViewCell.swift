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
    
    var presenter: DonateTableViewCellPresenter!
    
    override func awakeFromNib() {
        presenter = DonateTableViewCellPresenter()
        presenter.delegate = self
        
        donateCollectionView.register(UINib(nibName: "DonateCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: DonateCollectionViewCell.reuseIdentifier)
    }
    
    class func dequeueReusableCell(from tableView: UITableView, maxWidth: CGFloat) -> DonateTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DonateTableViewCell.reuseIdentifier) as! DonateTableViewCell
        cell.addDonateOptions(with: maxWidth)
        return cell
    }
    
    func addDonateOptions(with maxWidth: CGFloat) {
        let donatesCount: CGFloat = 3
        
        var cellWidth: CGFloat
        if (maxWidth / donatesCount) > 105 {
            cellWidth = 105
        } else {
            cellWidth = 90
        }
        
        let margin = (maxWidth - CGFloat(donatesCount * cellWidth)) / 4
        
        donateCollectionView.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        donateCollectionView.delegate = self
        donateCollectionView.dataSource = self
        
        let collectionViewFLowLayout = UICollectionViewFlowLayout()
        collectionViewFLowLayout.itemSize = CGSize(width: cellWidth, height: 140)
        collectionViewFLowLayout.minimumLineSpacing = 0
        collectionViewFLowLayout.minimumInteritemSpacing = 0
        
        donateCollectionView.collectionViewLayout = collectionViewFLowLayout
    }

}

extension DonateTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectDonateTypeByRow(indexPath.row)
    }
}

extension DonateTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.availableDonatesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DonateCollectionViewCell.dequeueReusableCell(from: collectionView, for: indexPath)
        
        if let donateType = presenter.getDonateTypeByRow(indexPath.row) {
            cell.setType(donateType)
        }
        
        return cell
    }
    
}

extension DonateTableViewCell: DonateTableViewCellDelegate {
    func reloadAvailableDonates() {
        donateCollectionView.reloadData()
    }
}
