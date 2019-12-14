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
    
    func priceInfoBuyRateAnimationRequired(oldBuyRateText: String) -> Bool {
        var animationBuyRate = false
        if oldBuyRateText != objSelectedBitcoinPriceInfo.buyRate {
            animationBuyRate = true
        }
        return animationBuyRate
    }
    
    func priceInfoSellRateAnimationRequired(oldSellRateText: String) -> Bool {
        var animationSellRate = false
        if oldSellRateText != objSelectedBitcoinPriceInfo.sellRate {
            animationSellRate = true
        }
        return animationSellRate
    }
}
