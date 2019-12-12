//
//  LandingScreenVC.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class LandingScreenVC: UIViewController {
        
    let viewModel = LandingScreenViewModel()

    // MARK: - ViewController LifeCycle
    init(nibName:String){
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(initialBitcoinPriceInfoAvailable(_:)), name: .firstTimeBitcoinPriceInfo, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods
    private func setUpData() {
        title = viewModel.navigationBarTitle
    }

    // MARK: - Notification Observer
    @objc func initialBitcoinPriceInfoAvailable(_ notification: Notification)
    {
       //first time setup of price info arra done and hence add key value observers for objects..
        for objPriceInfo in PriceInfoProvider.shared.bitcoinPriceInfoArray {//make sure it is not being updated???
            objPriceInfo.addObserver(self, forKeyPath: "buyRate", options: [.new,.old], context: nil)
            objPriceInfo.addObserver(self, forKeyPath: "sellRate", options: [.new,.old], context: nil)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                  of object: Any?,
                                  change: [NSKeyValueChangeKey : Any]?,
                                  context: UnsafeMutableRawPointer?) {
        guard let change = change else {
            return
        }
        
        if let oldValue = change[.oldKey] {
            print("Old value \(oldValue)")
        }
        
        if let newValue = change[.newKey]  {
            print("New value \(newValue)")
            if object is BitcoinPriceInfo {
                let obj = object as! BitcoinPriceInfo
                print("object currency \(obj.currencyName)")
            }
        }
        
    }
}
