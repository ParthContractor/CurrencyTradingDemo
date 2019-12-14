//
//  BitcoinPrice.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

public class BitcoinPriceInfo: NSObject {
    @objc dynamic var currencyName: String
    @objc dynamic var buyRate: String
    @objc dynamic var sellRate: String
    @objc dynamic var symbol: String
    var lastStoredBuyRate: String?
    var lastStoredSellRate: String?

    init(currencyName: String, buyRate: String, sellRate: String, symbol: String) {
        self.currencyName = currencyName
        self.buyRate = buyRate
        self.sellRate = sellRate
        self.symbol = symbol
        super.init()
    }
}

extension BitcoinPriceInfo {
    override public func isEqual(_ object: Any?) -> Bool {
        if let object = object as? BitcoinPriceInfo {
            let areEqual = self.currencyName == object.currencyName &&
                self.buyRate == object.buyRate &&
                self.sellRate == object.sellRate &&
                self.symbol == object.symbol
            return areEqual
        }
        return false
    }
}
