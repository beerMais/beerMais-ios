//
//  VersionTableViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class VersionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "VersionTableViewCell"
    
    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8
        
        return view
    }()
    
    lazy var versionLabel: UILabel = {
        let view = UILabel()
        view.text = "appVersion".localized
        
        return view
    }()
    
    lazy var versionNumberLabel: UILabel = {
        let view = UILabel()
        view.text = VersionP.getAppVersion()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func dequeueReusableCell(from tableView: UITableView) -> VersionTableViewCell {
        tableView.dequeueReusableCell(withIdentifier: VersionTableViewCell.reuseIdentifier) as! VersionTableViewCell
    }
}

extension VersionTableViewCell: ViewProtocol {
    func buildViews() {
        containerStackView.addArrangedSubviews([
            versionLabel,
            versionNumberLabel
        ])
    }
    
    func configViews() {
        addSubViews([
            containerStackView
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
