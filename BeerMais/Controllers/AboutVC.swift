//
//  AboutVC.swift
//  BeerMais
//
//  Created by José Neves on 02/04/19.
//  Copyright © 2019 joseneves. All rights reserved.
//

import Foundation
import UIKit

class AboutVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter: AboutP = {
        AboutP()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyVisuals()
        
        tableView.register(UINib(nibName: "AboutTableViewCell", bundle: nil),
                           forCellReuseIdentifier: AboutTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "VersionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: VersionTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "DonateTableViewCell", bundle: nil),
                           forCellReuseIdentifier: DonateTableViewCell.reuseIdentifier)
        
        tableView.dataSource = self
    }
    
    private func applyVisuals() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension AboutVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getRowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch presenter.getRowByIndex(indexPath.row) {
        case .description: return AboutTableViewCell.dequeueReusableCell(from: tableView)
        case .donate: return DonateTableViewCell.dequeueReusableCell(from: tableView, maxWidth: view.frame.width)
        case .version: return VersionTableViewCell.dequeueReusableCell(from: tableView)
        default: return UITableViewCell()
        }
    }
    
}
