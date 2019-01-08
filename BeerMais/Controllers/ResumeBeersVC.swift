//
//  ResumeBeersViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 25/12/18.
//  Copyright © 2018 joseneves. All rights reserved.
//

import UIKit


protocol ResumeBeersVCDelegate: class {
    func reloadBeers()
}

class ResumeBeersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var beersCollectionView: UICollectionView!
    
    var beers = [Beer]()
    var beerPresenter: BeerPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        self.rankView.layer.cornerRadius = 15
        self.rankView.layer.borderColor = UIColor.lightGray.cgColor
        self.rankView.layer.borderWidth = 0.5
        
        self.beersCollectionView.register(UINib(nibName: "BeerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "beerCollectionCell")
        
        self.beerPresenter = BeerPresenter()
        self.getBeers()
        
        self.addDelegate()
    }
    
    @IBAction func newBeerAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewBeer", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewBeerVCID") as! NewBeerVC
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.attachResumeBeersDelegate(delegate: self)
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.beers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let beer = self.beers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCollectionCell", for: indexPath) as! BeerCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.cornerRadius = 8
        
        cell.setAmount(amount: beer.amount)
        cell.setBrand(brand: beer.brand ?? "")
        cell.setValue(value: beer.value)
        cell.setType(type: beer.type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberOfCells = floor(self.view.frame.size.width / flowLayout.itemSize.width);
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * flowLayout.itemSize.width)) / (numberOfCells + 1);
        
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets);
    }
    
    private func addDelegate() {
        self.beersCollectionView.delegate = self
        self.beersCollectionView.dataSource = self
    }
    
    private func getBeers() {
        self.beerPresenter.getBeers() { beers in
            self.beers = beers
            self.beersCollectionView.reloadData()
        }
    }
}

extension ResumeBeersVC: ResumeBeersVCDelegate {
    internal func reloadBeers() {
        self.getBeers()
    }
}
