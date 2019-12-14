//
//  CurrencyOrderDetailsViewModel.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 13/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

class CurrencyOrderDetailsViewModel {
    let objSelectedBitcoinPriceInfo: BitcoinPriceInfo
    var navigationTitle: String {
           return "Bitcoin Price" + "::" + self.objSelectedBitcoinPriceInfo.currencyName
    }

    init(_ bitcoinPriceInfo: BitcoinPriceInfo) {
        self.objSelectedBitcoinPriceInfo = bitcoinPriceInfo
    }
}
