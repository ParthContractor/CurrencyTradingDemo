//
//  PriceInfoProvider.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
import UIKit

final class PriceInfoProvider{
    static let shared = PriceInfoProvider()
    private var priceUpdateTimer: Timer!

    private init(){
        startTimer()
        addObservers()
    }
    
    @objc private func priceUpdate() {
        fetchLatestPriceInfo()
    }
    
    private(set) var bitcoinPriceInfoArray = [BitcoinPrice]()

    func fetchLatestPriceInfo() {
        self.bitcoinPriceInfoArray.removeAll()
        self.getBitcoinPriceInfo(completion: { (success) -> () in
            self.sortByCurrencyName()
            print("\(self.bitcoinPriceInfoArray)")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .fetchLatestBitcoinPriceInfo, object: nil)
            }
        })
    }
    
    func sortByCurrencyName() {
        self.bitcoinPriceInfoArray.sort { ($0.currencyName) < ($1.currencyName) }
     }
        
    private func getBitcoinPriceInfo(completion: @escaping (_ infoAdded: Bool) -> ()) {
        guard let url = URL(string: Constants.APIConstants.bitcoinPriceInfoURL) else {fatalError("Bitcoin Price Info URL is wrong")}

        let request = NSMutableURLRequest(url: url)
    
        APIUtility.get(request: request) { (success, returnObject) -> () in
            DispatchQueue.main.async {
              if success {
                guard let data = returnObject.1 else { return }
                let containerData = try? JSONDecoder().decode(Containers.self, from: data)
                if let priceData = containerData {
                    self.populateDataToBitcoinPriceList(priceData)
                }
                completion(true)
              } else {
                  var message = "Some error found"
                  if let object = returnObject.0, let passedMessage = object["message"] as? String {
                      message = passedMessage
                  }
                print(message)
                completion(false)
              }
            }
        }
    }
    
    // MARK: - Notification Observer and helpers
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        stopTimer()
    }
    
    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        startTimer()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name:UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func startTimer(){
        priceUpdateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.latestPriceInfoPollingPeriod), target: self, selector: #selector(priceUpdate), userInfo: nil, repeats: true)
        // Helps UI stay responsive even with timer.
        RunLoop.current.add(priceUpdateTimer, forMode: RunLoop.Mode.common)
    }
    
    private func stopTimer(){
        priceUpdateTimer.invalidate()
        priceUpdateTimer = nil
    }
    
    private func populateDataToBitcoinPriceList(_ container: Containers) {
          for containerInnerItem in container.inner {
              if containerInnerItem.title.count != 0, let buyRate = containerInnerItem.buy, let sellRate = containerInnerItem.sell {
                self.bitcoinPriceInfoArray.append(BitcoinPrice(currencyName: containerInnerItem.title, buyRate: buyRate.roundedStringValue(to: 2), sellRate: sellRate.roundedStringValue(to: 2), symbol: containerInnerItem.symbol))
              }
          }
      }
}
