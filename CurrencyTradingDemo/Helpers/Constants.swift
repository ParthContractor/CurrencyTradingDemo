//
//  Constants.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

struct Constants {
    static let latestPriceInfoPollingPeriod = 15

    struct APIConstants {
           static let bitcoinPriceInfoURL = "https://blockchain.info/ticker"
    }
}

extension Notification.Name {
    static let firstTimeBitcoinPriceInfo = Notification.Name("firstTimeBitcoinPriceInfo")
    static let followUpReloadPriceInfo = Notification.Name("followUpReloadPriceInfo")
}

extension UIFont {
    struct ThemeFont {
        static let currencyRatesListTitleFont = UIFont.systemFont(ofSize: 25)
        static let currencyRatesListDetailFont = UIFont.systemFont(ofSize: 20)
    }
}

extension UIColor {
    struct ThemeColor {
        static let navigationBarTintColor = UIColor.orange
        static let navigationTintColor = UIColor.yellow
        static let currencyNameDisplayColor = UIColor.lightText
        static let currencyBuyRateColor = UIColor.white
        static let currencySellRateColor = UIColor.white
    }
}
