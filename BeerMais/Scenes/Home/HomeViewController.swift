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
    func reloadBeers()
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
        
        view.register(
            BeerCollectionViewCell.self,
            forCellWithReuseIdentifier: BeerCollectionViewCell.customReuseIdentifier
        )
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
    
    @objc func newBeerAction(_ sender: Any) {
        openDetails()
    }
    
    @objc func deleteBeersAction(_ sender: Any) {
        let viewController = AlertFactory.build(with: .init(title: "deleteTitle".localized,
                                                            description: "deleteBeerAlert".localized,
                                                            negativeActionTitle: "backScreen".localized,
                                                            positiveActionTitle: "delete".localized,
                                                            negativeAction: nil,
                                                            positiveAction: { [weak self] in
            self?.interactor?.deleteAllBeers()
        }))
        
        viewController.modalPresentationStyle = .overCurrentContext
        
        if tabBarController != nil {
            tabBarController?.present(viewController, animated: true)
        } else {
            present(viewController, animated: true)
        }
    }
    
    private func openDetails(with beer: Beer? = nil) {
        let viewController = DetailsFactory.build(with: beer, delegate: self)
        viewController.modalPresentationStyle = .overCurrentContext
        
        if tabBarController != nil {
            tabBarController?.present(viewController, animated: true)
        } else {
            present(viewController, animated: true)
        }
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
    
    func reloadBeers() {
        interactor?.reloadBeers()
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
        openDetails(with: beers[indexPath.row])
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BeerCollectionViewCell.customReuseIdentifier,
            for: indexPath
        ) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setBeer(beer: beer)
        cell.setCounter(counter: indexPath.row + 1)
        
        return cell
    }
    
}

extension HomeViewController: ViewProtocol {
    func buildViews() {
        view.backgroundColor = BeerColors.whiteBlack
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = BeerColors.primary
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "appName".localized
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteBeersAction(_:)))
        leftButton.tintColor = BeerColors.blackWhite
        navigationItem.setLeftBarButton(leftButton, animated: true)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add,
                                          target: self,
                                          action: #selector(newBeerAction(_:)))
        rightButton.tintColor = BeerColors.blackWhite
        navigationItem.setRightBarButton(rightButton, animated: true)
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
