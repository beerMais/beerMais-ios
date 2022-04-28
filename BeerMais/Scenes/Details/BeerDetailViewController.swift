//
//  DetailsViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 25/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol DetailsViewControllerProtocol {
    
}

final class DetailsViewController: UIViewController {
    
    var interactor: DetailsInteractor?
    
    lazy var beerDetailView: BeerDetailView = {
        let view = BeerDetailView()
        view.setupViews()
        
        return view
    }()
    
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
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - DetailsViewControllerProtocol

extension DetailsViewController: DetailsViewControllerProtocol {
    
}

// MARK: - ViewProtocol

extension DetailsViewController: ViewProtocol {
    
    func buildViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.25)
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
