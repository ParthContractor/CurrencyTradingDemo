//
//  PriceInfoProvider.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation
import UIKit

typealias BitcoinPriceInfoCheck = (exists: Bool, matchedObj: BitcoinPriceInfo?, matchedIndex: Int?)

final class PriceInfoProvider {
    static let shared = PriceInfoProvider()
    private var priceUpdateTimer: Timer!
    private var firstTimeDataSetUp = false

    private init(){
        startTimer()
        addObservers()
    }
    
    @objc private func priceUpdate() {
        fetchLatestPriceInfo()
    }
    
    private(set) var bitcoinPriceInfoArray = [BitcoinPriceInfo]()

    func fetchLatestPriceInfo() {
        self.getBitcoinPriceInfo(completion: { (success) -> () in
            print("count is: \(self.bitcoinPriceInfoArray.count)")
            if self.firstTimeDataSetUp == false {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .firstTimeBitcoinPriceInfo, object: nil)
                    //post notification only once initially...
                    self.firstTimeDataSetUp = true
                }
            }
            else{
                //reload visible data after update....
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .followUpReloadPriceInfo, object: nil)
                }
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
                let newObj = BitcoinPriceInfo(currencyName: containerInnerItem.title, buyRate: buyRate.roundedStringValue(to: 2), sellRate: sellRate.roundedStringValue(to: 2), symbol: containerInnerItem.symbol)
                
                let bitCoinPriceInfoCheck = checkIfObjectExists(newObj.currencyName)
                if let matchedObj = bitCoinPriceInfoCheck.matchedObj {
                    if newObj != matchedObj {
                        //update in existing element found hence update it in array and notify..
                        self.bitcoinPriceInfoArray[bitCoinPriceInfoCheck.matchedIndex!].setValue(newObj.currencyName, forKey:"currencyName")
                        self.bitcoinPriceInfoArray[bitCoinPriceInfoCheck.matchedIndex!].setValue(newObj.buyRate, forKey:"buyRate")
                        self.bitcoinPriceInfoArray[bitCoinPriceInfoCheck.matchedIndex!].setValue(newObj.sellRate, forKey:"sellRate")
                        self.bitcoinPriceInfoArray[bitCoinPriceInfoCheck.matchedIndex!].setValue(newObj.symbol, forKey:"symbol")
                        print("update")
                    }
                    else{
                        print("no update")
                    }
                }
                else{
                    //new element found hence add it in array and notify..
                    newObj.ID = self.bitcoinPriceInfoArray.count
                    self.bitcoinPriceInfoArray.append(newObj)
                    print("addition")
                }
              }
          }
      }
    
    private func checkIfObjectExists(_ currencyIdentifier: String) -> BitcoinPriceInfoCheck {
        let matchedObject = self.bitcoinPriceInfoArray.first{ $0.currencyName == currencyIdentifier}
        if let objFound = matchedObject {
            let indexOfFoundObject = self.bitcoinPriceInfoArray.firstIndex { $0.currencyName == currencyIdentifier}
            return (true,objFound,indexOfFoundObject)
        } else {
            return (false,nil,nil)
        }
    }
}
