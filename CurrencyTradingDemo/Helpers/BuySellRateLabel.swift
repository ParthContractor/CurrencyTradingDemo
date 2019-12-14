//
//  BuySellRateLabel.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 14/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class BuySellRateLabel: UILabel {
    
    var lastStoredText: String = ""
    
    var customText: String = "" {
        willSet(newValue) {
            let components = newValue.components(separatedBy: ".")
            let strBeforeDecimal = components[safeIndex: 0]
            let strAfterDecimal = components[safeIndex: 1]
            let attrString = NSMutableAttributedString(string: strBeforeDecimal!,
                                                       attributes: [NSAttributedString.Key.font: UIFont.ThemeFont.currencyRatesListDetailFont])
            attrString.append(NSMutableAttributedString(string: ".",
                                                        attributes: [NSAttributedString.Key.font: UIFont.ThemeFont.currencyRatesListDetailFont]))
            attrString.append(NSMutableAttributedString(string: strAfterDecimal!,
                                                        attributes: [NSAttributedString.Key.font: UIFont.tinyInformationFont]))
            attributedText = attrString
        }
    }
    
}
