//
//  VersionTableViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class VersionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    static let reuseIdentifier = "VersionTableViewCell"
    
    class func dequeueReusableCell(from tableView: UITableView) -> VersionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VersionTableViewCell.reuseIdentifier) as! VersionTableViewCell
        cell.versionLabel.text = VersionP.getAppVersion()
        
        return cell
    }
}
