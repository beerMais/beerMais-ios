//
//  BeerImage.swift
//  BeerMais
//
//  Created by Jose Neves on 02/05/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import UIKit
import SwiftUI

@MainActor
final class BeerImage {
    static var iconRounded = UIImage(named: "icon_rounded", in: .beerMais, with: nil)!
    static var iconBeerCan100 = UIImage(named: "icons8-beer-can-100", in: .beerMais, with: nil)!
    static var iconBeerBottle100 = UIImage(named: "icons8-beer-bottle-100", in: .beerMais, with: nil)!
    
    static var iconRoundedUI = Image("icon_rounded", bundle: .beerMais)
    static var iconBeerCan100UI = Image("icons8-beer-can-100", bundle: .beerMais)
    static var iconBeerBottle100UI = Image("icons8-beer-bottle-100", bundle: .beerMais)
    static var iconBeerBottles100UI = Image("icons8-bottles-100", bundle: .beerMais)
}
