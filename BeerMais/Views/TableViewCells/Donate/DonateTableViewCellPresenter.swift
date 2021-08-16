//
//  DonateTableViewCellPresenter.swift
//  BeerMais
//
//  Created by Jose Neves on 16/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import Foundation

class DonateTableViewCellPresenter {
    
    var availableDonates: [DonateType] = [.small, .medium, .large]
    
    func availableDonatesCount() -> Int {
        return availableDonates.count
    }
    
    func getDonateTypeByRow(_ row: Int) -> DonateType? {
        if row >= availableDonates.count {
            return nil
        }
        
        return availableDonates[row]
    }
    
    func didSelectDonateTypeByRow(_ row: Int) {
        guard let donateType = getDonateTypeByRow(row) else {
            return
        }
        
        print(donateType)
        
        
    }

}
