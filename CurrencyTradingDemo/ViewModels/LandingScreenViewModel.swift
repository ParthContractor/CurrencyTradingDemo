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
        str = "Buy @ " + obj.symbol + " " + obj.buyRate
        return str
    }
    
    func sellRateLabelValue(_ row: Int) -> String {
        var str = String()
        guard let obj = PriceInfoProvider.shared.bitcoinPriceInfoArray[safeIndex: row] else {
            return str
        }
        str = "Sell @ " + obj.symbol + " " + obj.sellRate
        return str
    }
    
    func initialDataLoading(){
        //initial setup of shared price info provider
        PriceInfoProvider.shared.fetchLatestPriceInfo()
    }
}
