//
//  DetailsViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol DetailsViewControllerProtocol {
    func setupData(with beer: Beer)
    func reloadBeers()
    func close()
    func animateViewMoving(up: Bool, moveValue: CGFloat)
}

final class DetailsViewController: UIViewController {
    
    lazy var beerDetailView: BeerDetailView = {
        let view = BeerDetailFactory.build(with: beer, delegate: self)
        view.setupViews()
        
        return view
    }()
    
    var interactor: DetailsInteractor?
    var delegate: HomeViewControllerProtocol?
    private var beer: Beer?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        let touch = touches.first
        guard let location = touch?.location(in: view) else { return }
        
        if !beerDetailView.frame.contains(location) {
            close()
        }
    }
}

// MARK: - DetailsViewControllerProtocol

extension DetailsViewController: DetailsViewControllerProtocol {
    
    func setupData(with beer: Beer) {
        self.beer = beer
        
        setupViews()
    }
    
    func reloadBeers() {
        delegate?.reloadBeers()
    }
    
    func close() {
        delegate?.reloadBeers()
        dismiss(animated: true)
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat) {
        let movementDuration:TimeInterval = 0.3
        let movement: CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        view.frame = view.frame.offsetBy(dx: 0, dy: movement)
        
        UIView.commitAnimations()
    }
}

// MARK: - ViewProtocol

extension DetailsViewController: ViewProtocol {
    
    func buildViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
    
    func configViews() {
        view.addSubViews([beerDetailView])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            beerDetailView.widthAnchor.constraint(equalToConstant: 300),
            beerDetailView.heightAnchor.constraint(equalToConstant: 300),
            beerDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            beerDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
