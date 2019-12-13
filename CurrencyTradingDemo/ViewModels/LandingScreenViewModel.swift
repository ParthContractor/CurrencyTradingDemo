//
//  LandingScreenViewModel.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

class LandingScreenViewModel {
    let navigationBarTitle: String

    init() {
        self.navigationBarTitle = "Bitcoin Trading"
    }
    
    func priceInfoRateAnimationRequired(_ row: Int, oldBuyRateText: String, oldSellRateText: String) -> (Bool,Bool) {
        var animationBuyRate = false
        var animationSellRate = false
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else{
            return (animationBuyRate, animationSellRate)
        }

        if oldBuyRateText != obj.buyRate {
            animationBuyRate = true
        }
        if oldSellRateText != obj.sellRate {
            animationSellRate = true
        }
        return (animationBuyRate, animationSellRate)
    }
        
    func priceInfoObjectAt(_ row: Int) -> BitcoinPriceInfo? {
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else{
            return nil
        }
        return obj
    }
    
    func currencyLabelValue(_ row: Int) -> String {
        var str = String()
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else{
            return str
        }
        str = obj.currencyName
        return str
    }
    
    func buyRateLabelValue(_ row: Int) -> String {
        var str = String()
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else{
            return str
        }
        str = formattedBuyRate(strSymbol: obj.symbol, strBuyRate: obj.buyRate)
        obj.lastStoredBuyRate = obj.buyRate
        return str
    }
    
    func sellRateLabelValue(_ row: Int) -> String {
        var str = String()
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else {
            return str
        }
        str = formattedSellRate(strSymbol: obj.symbol, strSellRate: obj.sellRate)
        obj.lastStoredSellRate = obj.sellRate
        return str
    }
    
    private func formattedBuyRate(strSymbol: String, strBuyRate: String) -> String {
           var str = String()
           str = "Buy @ " + strSymbol + " " + strBuyRate
           return str
    }
    
    private func formattedSellRate(strSymbol: String, strSellRate: String) -> String {
           var str = String()
           str = "Sell @ " + strSymbol + " " + strSellRate
           return str
    }
    
    func initialDataLoading(){
        //initial setup of shared price info provider
        PriceInfoProvider.shared.fetchLatestPriceInfo()
    }
}
