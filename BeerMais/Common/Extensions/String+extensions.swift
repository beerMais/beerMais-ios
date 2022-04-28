//
//  String+extensions.swift
//  BeerMais
//
//  Created by Jose Neves on 27/04/22.
//  Copyright © 2022 joseneves. All rights reserved.
//

import Foundation

extension String {
    
    var toInt16: Int16 {
        return Int16(self) ?? 0
    }
    
    var parseStringValueToFloat: Float {
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSMakeRange(0, amountWithPrefix.count),
                                                          withTemplate: "")

        let floatValue = (amountWithPrefix as NSString).floatValue
        
        return NSNumber(value: (floatValue / 100)).floatValue
    }
}
