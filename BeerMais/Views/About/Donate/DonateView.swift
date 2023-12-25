//
//  DonateView.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class DonateView: UIView {
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .justified
        view.text = "Se você já economizou usando o Beer Mais na hora de escolher a melhor bebida e deseja contibuir com a manutenção do app, qualquer valor é de grande ajuda 🍻"
        
        return view
    }()
    
    lazy var donateCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.delegate = self
        view.dataSource = self
        view.register(
            DonateCollectionViewCell.self,
            forCellWithReuseIdentifier: DonateCollectionViewCell.reuseIdentifier
        )
        
        return view
    }()
    
    lazy var presenter: DonateViewPresenter = {
        let presenter = DonateViewPresenter()
        presenter.delegate = self
        
        return presenter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let collectionViewFLowLayout = UICollectionViewFlowLayout()
        collectionViewFLowLayout.itemSize = CGSize(width: cellWidth, height: 140)
        collectionViewFLowLayout.minimumLineSpacing = 0
        collectionViewFLowLayout.minimumInteritemSpacing = 0
        
        donateCollectionView.collectionViewLayout = collectionViewFLowLayout
    }

}

extension DonateView: ViewProtocol {
    func buildViews() {}
    
    func configViews() {
        addSubViews([
            descriptionLabel,
            donateCollectionView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            donateCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            donateCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            donateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            donateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            donateCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }
}

extension DonateView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectDonateTypeByRow(indexPath.row)
    }
}

extension DonateView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.availableDonatesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DonateCollectionViewCell.reuseIdentifier, for: indexPath
        ) as? DonateCollectionViewCell else { return UICollectionViewCell() }
        
        if let donateProduct = presenter.getDonateTypeByRow(indexPath.row) {
            cell.setDonate(donateProduct)
        }
        
        return cell
    }
    
}

extension DonateView: DonateViewDelegate {
    func reloadAvailableDonates() {
        donateCollectionView.reloadData()
    }
}
