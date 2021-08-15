//
//  AboutP.swift
//  BeerMais
//
//  Created by Jose Neves on 14/08/21.
//  Copyright © 2021 joseneves. All rights reserved.
//

import Foundation

enum AboutRow {
    case description
    case donate
    case version
}

class AboutP {
    var availableRows: [AboutRow] = [.description, .donate, .version]
    
    func getRowsCount() -> Int {
        return availableRows.count
    }
    
    func getRowByIndex(_ index: Int) -> AboutRow? {
        if index >= availableRows.count {
            return nil
        }
        
        return availableRows[index]
    }
}
