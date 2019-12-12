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
    static let fetchLatestBitcoinPriceInfo = Notification.Name("fetchLatestBitcoinPriceInfo")
}

