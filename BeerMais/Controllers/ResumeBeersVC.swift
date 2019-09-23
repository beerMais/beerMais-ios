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
    var beerP: BeerP!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rankView.layer.cornerRadius = 15
        self.setBorderToRank()
        
        self.beersCollectionView.register(UINib(nibName: "BeerCollectionCell", bundle: nil), forCellWithReuseIdentifier: "beerCollectionCell")
        
        self.beerP = BeerP()
        self.getBeers()
        
        self.addDelegate()
    }
    
    @IBAction func newBeerAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewBeer", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewBeerVCID") as! NewBeerVC
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.attachResumeBeersDelegate(delegate: self)
        
        if self.tabBarController != nil {
            self.tabBarController?.present(viewController, animated: true, completion: nil)
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteBeersAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "AlertVCID") as! AlertVC
        viewController.modalPresentationStyle = .overCurrentContext
        
        if self.tabBarController != nil {
            self.tabBarController?.present(viewController, animated: true, completion: nil)
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
        
        viewController.setTitle(title: "Apagar?")
        viewController.setBody(body: "Deseja apagar todas as cervejas? Essa ação não terá volta.")
        viewController.setNegativeAction(text: "Voltar")
        viewController.setPositiveAction({
            self.deleteBeers()
        }, text: "Apagar")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let lines = self.beers.count
        var backgroundView = UIView()
        
        if (lines == 0) {
            let message = UILabel()
            message.textColor = UIColor.darkGray
            message.text = "helpBeerText".localized
            message.textAlignment = .center
            message.numberOfLines = 2
            
            backgroundView = message
        }
        
        self.beersCollectionView.backgroundView = backgroundView
        return lines
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let beer = self.beers[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCollectionCell", for: indexPath) as! BeerCollectionViewCell
        
        cell.setAmount(amount: beer.amount)
        cell.setBrand(brand: beer.brand ?? "")
        cell.setValue(value: beer.value)
        cell.setType(type: beer.type)
        cell.setCounter(counter: indexPath.row + 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberOfCells = floor(self.view.frame.size.width / flowLayout.itemSize.width);
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * flowLayout.itemSize.width)) / (numberOfCells + 1);
        
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let beer = self.beers[indexPath.row]
        
        let storyboard = UIStoryboard(name: "NewBeer", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewBeerVCID") as! NewBeerVC
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.attachResumeBeersDelegate(delegate: self)
        viewController.setBeer(beer: beer)
        
        if self.tabBarController != nil {
            self.tabBarController?.present(viewController, animated: true, completion: nil)
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func addDelegate() {
        self.beersCollectionView.delegate = self
        self.beersCollectionView.dataSource = self
    }
    
    private func getBeers() {
        self.beerP.getBeers() { beers in
            self.setBeers(beers: beers)
            self.beersCollectionView.reloadData()
        }
    }
    
    private func setBeers(beers: [Beer]) {
        self.beers = self.beerP.calculateMostValuable(beers: beers)
        self.setRank()
    }
    
    private func setRank() {
        self.setBorderToRank()
        
        if (self.beers.count < 2) {
            self.rankBrandLabel.text = "brand".localized
            self.rankBeerImageView.image = UIImage(named: "icons8-beer-can-100")
            self.rankAmountLabel.text = "350ml"
            self.rankValueLabel.text = "RS 0,00"
            self.rankEconomyLabel.text = "R$ 0,00/L"
            return
        }
        
        let beer = self.beers[0]
        
        self.rankBrandLabel.text = beer.brand
        
        var amountText = "\(beer.amount)ml"
        
        if (beer.amount >= 1000) {
            amountText = "1 L"
            
            if (beer.amount >= 1010) {
                var amountString = String(format: "%.2f", Float(beer.amount) / 1000)
                amountString = amountString.replacingOccurrences(of: ".", with: ",")
                amountText = "\(amountString) L"
            }
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
        
        let valueString = self.beerP.formatValueToShow(value: beer.value)
        self.rankValueLabel.text = "R$ \(valueString)"
        
        let economy = self.beerP.getEconomy(beer1: beer, beer2: self.beers[1])
        let economyFormated = self.beerP.formatValueToShow(value: economy)
        self.rankEconomyLabel.text = "R$ \(economyFormated)/L"
    }
    
    private func deleteBeers() {
        self.setBeers(beers: [])
        self.beersCollectionView.reloadData()
        self.beerP.deleteBeers()
    }
    
    private func setBorderToRank() {
        var borderColor = UIColor.lightGray
        var borderWidth = 0.5
        var backgroundColor = UIColor.white
        
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.tertiarySystemBackground
        }
    
        if (self.beers.count > 1) {
            borderColor = UIColor(red: 0.00, green: 0.78, blue: 0.33, alpha: 1.0)
            borderWidth = 2
            backgroundColor = UIColor(named: "economyBackground")!
        }
        
        self.rankView.layer.borderColor = borderColor.cgColor
        self.rankView.layer.borderWidth = CGFloat(borderWidth)
        self.rankView.backgroundColor = backgroundColor
    }
    
}

extension ResumeBeersVC: ResumeBeersVCDelegate {
    internal func reloadBeers() {
        self.getBeers()
    }
}
