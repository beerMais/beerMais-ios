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
    @IBOutlet weak var rankBrandLabel: UILabel!
    @IBOutlet weak var rankBeerImageView: UIImageView!
    @IBOutlet weak var rankValueLabel: UILabel!
    @IBOutlet weak var rankAmountLabel: UILabel!
    @IBOutlet weak var rankEconomyLabel: UILabel!
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
    
    @IBAction func deleteBeersAction(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Deseja apagar todas as cervejas?", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Apagar", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteBeers()
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: nil))
        
        self.present(deleteAlert, animated: true, completion: nil)
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
            self.setBeers(beers: beers)
            self.beersCollectionView.reloadData()
        }
    }
    
    private func setBeers(beers: [Beer]) {
        self.beers = self.beerPresenter.calculateMostValuable(beers: beers)
        self.setRank()
    }
    
    private func setRank() {
        if (self.beers.count < 2) {
            self.rankBrandLabel.text = "Marca"
            self.rankValueLabel.text = "RS 0,00"
            self.rankEconomyLabel.text = "R$ 0,00/L"
            return
        }
        
        let beer = self.beers[0]
        
        self.rankBrandLabel.text = beer.brand
        
        var amountText = "\(beer.amount)ml"
        
        if (beer.amount >= 1000) {
            amountText = "\(beer.amount / 1000)L"
        }
        self.rankAmountLabel.text = amountText
        
        var imageName = ""
        switch beer.type {
        case 1:
            imageName = "icons8-beer-can-100"
        case 2:
            imageName = "icons8-beer-bottle-100"
        default:
            imageName = "icons8-beer-can-100"
        }
        
        self.rankBeerImageView.image = UIImage(named: imageName)
        
        self.rankValueLabel.text = "RS \(beer.value)"
        
        let economy = self.beerPresenter.getEconomy(beer1: beer, beer2: self.beers[1])
        let economyFormated = String(format: "%.2f", economy)
        self.rankEconomyLabel.text = "R$ \(economyFormated)/L"
    }
    
    private func deleteBeers() {
        self.setBeers(beers: [])
        self.beersCollectionView.reloadData()
        self.beerPresenter.deleteBeers()
    }
    
}

extension ResumeBeersVC: ResumeBeersVCDelegate {
    internal func reloadBeers() {
        self.getBeers()
    }
}
