//
//  AboutViewController.swift
//  BeerMais
//
//  Created by Jose Neves on 01/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit

protocol AboutViewControllerProtocol {
    func showItems(with availableRows: [AboutRow])
}

final class AboutViewController: UIViewController {
    
    var interactor: AboutInteractorProtocol?
    
    lazy var headerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        view.alignment = .center
        view.distribution = .equalCentering
        
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = BeerImage.iconRounded
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "appName".localized
        view.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        view.textColor = BeerColors.primary
        
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()
    
    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    var donateView: DonateView?
    
    private var availableRows: [AboutRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
}

extension AboutViewController: AboutViewControllerProtocol {
    func showItems(with availableRows: [AboutRow]) {
        self.availableRows = availableRows
        
        setupViews()
    }
}

extension AboutViewController: ViewProtocol {
    
    func buildViews() {
        view.backgroundColor = .systemBackground
    }
    
    func configViews() {
        headerStackView.addArrangedSubviews([
            iconImageView,
            titleLabel
        ])
        
        var views: [UIView] = [headerStackView]
        
        availableRows.forEach {
            switch $0 {
            case .description:
                views.append(AppDescriptionView())
            case .donate:
                let donateView = DonateView()
                donateView.addDonateOptions(with: view.frame.width)
                
                views.append(donateView)
            case .version:
                views.append(VersionView())
            }
        }
        containerStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        containerStackView.addArrangedSubviews(views)
        
        scrollView.addSubViews([
            containerStackView
        ])
        
        view.addSubViews([
            scrollView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            headerStackView.heightAnchor.constraint(equalToConstant: 66),
        ])
    }
    
}
