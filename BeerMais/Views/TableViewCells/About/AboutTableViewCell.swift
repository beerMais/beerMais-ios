//
//  AboutTableViewCell.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import UIKit

final class AboutTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "AboutTableViewCell"
    
    class func dequeueReusableCell(from tableView: UITableView) -> AboutTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.reuseIdentifier) as! AboutTableViewCell
    }
}
