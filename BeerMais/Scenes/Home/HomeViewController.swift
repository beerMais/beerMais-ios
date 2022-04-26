//
//  HomeViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func setBeers(with beers: [Beer])
    func setDefaultDataToRank()
    func highligthBeer(_ beer: Beer, economy: String)
}

final class HomeViewController: UIViewController {
    
    lazy var rankView: RankBeerView = {
        let view = RankBeerView()
        view.setupViews()
        
        return view
    }()
    
    lazy var beersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 170, height: 115)
        
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        
        view.register(UINib(nibName: "BeerCollectionCell", bundle: nil),
                      forCellWithReuseIdentifier: "beerCollectionCell")
        view.backgroundColor = BeerColors.whiteBlack
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    var interactor: HomeInteractorProtocol?
    private var beers = [Beer]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeViewController: HomeViewControllerProtocol {
    func setBeers(with beers: [Beer]) {
        self.beers = beers
        beersCollectionView.reloadData()
    }
    
    func setDefaultDataToRank() {
        rankView.setDefaultData()
    }
    
    func highligthBeer(_ beer: Beer, economy: String) {
        rankView.setBorderStyle(isHighlighted: true)
        rankView.setBeerData(with: beer, economy: economy)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberOfCells = floor(self.view.frame.size.width / flowLayout.itemSize.width);
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * flowLayout.itemSize.width)) / (numberOfCells + 1);
        
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets);
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let beer = self.beers[indexPath.row]
        
        let storyboard = UIStoryboard(name: "NewBeer", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewBeerVCID") as! NewBeerVC
        viewController.modalPresentationStyle = .overCurrentContext
//        viewController.attachResumeBeersDelegate(delegate: self)
        viewController.setBeer(beer: beer)
        
        if self.tabBarController != nil {
            self.tabBarController?.present(viewController, animated: true, completion: nil)
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let lines = beers.count
        var backgroundView = UIView()
        
        if (lines == 0) {
            let message = UILabel()
            message.textColor = UIColor.darkGray
            message.text = "helpBeerText".localized
            message.textAlignment = .center
            message.numberOfLines = 2
            
            backgroundView = message
        }
        
        beersCollectionView.backgroundView = backgroundView
        
        return lines
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let beer = beers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCollectionCell",
                                                      for: indexPath) as! BeerCollectionViewCell
        
        cell.setAmount(amount: beer.amount)
        cell.setBrand(brand: beer.brand ?? "")
        cell.setValue(value: beer.value)
        cell.setType(type: beer.type)
        cell.setCounter(counter: indexPath.row + 1)
        
        return cell
    }
    
}

extension HomeViewController: ViewProtocol {
    func buildViews() {
        view.backgroundColor = BeerColors.whiteBlack
    }
    
    func configViews() {
        view.addSubViews([rankView,
                          beersCollectionView])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rankView.heightAnchor.constraint(equalToConstant: 125),
            rankView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            rankView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rankView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            beersCollectionView.topAnchor.constraint(equalTo: rankView.bottomAnchor, constant: 16),
            beersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            beersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            beersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
