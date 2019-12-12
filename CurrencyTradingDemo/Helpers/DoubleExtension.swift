//
//  DoubleExtension.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

extension Double {
    func roundedStringValue(to places: Int) -> String {
        let format = "%." + "\(places)f"
        return String(format: format, self)
    }
}
