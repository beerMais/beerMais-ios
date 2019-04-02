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
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionLabel.text = VersionP().getAppVersion()
    }
}
