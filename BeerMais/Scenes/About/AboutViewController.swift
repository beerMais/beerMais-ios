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
        view.distribution = .fill
        
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
    
    lazy var contentTableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.dataSource = self
        
        view.register(UINib(nibName: "AboutTableViewCell", bundle: nil),
                      forCellReuseIdentifier: AboutTableViewCell.reuseIdentifier)
        view.register(UINib(nibName: "VersionTableViewCell", bundle: nil),
                      forCellReuseIdentifier: VersionTableViewCell.reuseIdentifier)
        view.register(UINib(nibName: "DonateTableViewCell", bundle: nil),
                      forCellReuseIdentifier: DonateTableViewCell.reuseIdentifier)
        
        return view
    }()
    
    private var availableRows: [AboutRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
}

extension AboutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch availableRows[indexPath.row] {
        case .description:
            return AboutTableViewCell.dequeueReusableCell(from: tableView)
        case .donate:
            return DonateTableViewCell.dequeueReusableCell(from: tableView, maxWidth: view.frame.width)
        case .version:
            return VersionTableViewCell.dequeueReusableCell(from: tableView)
        }
    }
}

extension AboutViewController: AboutViewControllerProtocol {
    func showItems(with availableRows: [AboutRow]) {
        self.availableRows = availableRows
        
        contentTableView.reloadData()
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
        
        view.addSubViews([
            headerStackView,
            contentTableView
        ])
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentTableView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}
