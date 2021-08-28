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
        let donatesCount = 3
        let margin: CGFloat = 5
        donateCollectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        donateCollectionView.delegate = self
        donateCollectionView.dataSource = self
        
        let collectionViewFLowLayout = UICollectionViewFlowLayout()

        let totalWidth = Int(maxWidth - (margin * CGFloat(donatesCount + 1)))
        collectionViewFLowLayout.itemSize = CGSize(width: totalWidth / donatesCount,
                                                   height: 190)
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
