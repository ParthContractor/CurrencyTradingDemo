//
//  CurrencyOrderDetailsVC.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 13/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class CurrencyOrderDetailsVC: UIViewController {
    
    let viewModel: CurrencyOrderDetailsViewModel
    
    @IBOutlet var lblBUY: UILabel!
    @IBOutlet var lblSELL: UILabel!
    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var stackViewBottomOrderButtons: UIStackView!
    @IBOutlet var lblBuyRate: UILabel!
    @IBOutlet var lblSellRate: UILabel!
    @IBOutlet var lblSpreadCalculation: UILabel!
        
    private var strBuyRate: String! {
        didSet {
            lblBuyRate.text = strBuyRate
            spreadCalculation()
        }
    }

    private var strSellRate: String! {
        didSet {
            lblSellRate.text = strSellRate
            spreadCalculation()
        }
    }
    
    // MARK: - ViewController LifeCycle
    init(nibName:String, viewModel: CurrencyOrderDetailsViewModel){
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewBottomOrderButtons.setCustomSpacing(10.0, after: btnCancel)
        navigationItem.setHidesBackButton(true, animated:true);
//        initialSetUp()
        addObservers()
        setUpData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        removeObservers()
    }

    // MARK: - Actions/Events
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnConfirmTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSellPanelTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBuyPanelTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Helpers
    private func setUpData(){
        strBuyRate = viewModel.objSelectedBitcoinPriceInfo.buyRate
        strSellRate = viewModel.objSelectedBitcoinPriceInfo.sellRate
        title = viewModel.navigationTitle
    }
    
    private func spreadCalculation(){
        if strSellRate != nil, strSellRate != nil, let sell = Double(strSellRate), let buy = Double(strBuyRate) {
            lblSpreadCalculation.text = (sell - buy).roundedStringValue(to: 2)
        }
    }
    
    private func addObservers(){
        viewModel.objSelectedBitcoinPriceInfo.addObserver(self, forKeyPath: Constants.buyRateKeyPath, options: [.new,.old], context: nil)
        viewModel.objSelectedBitcoinPriceInfo.addObserver(self, forKeyPath: Constants.sellRateKeyPath, options: [.new,.old], context: nil)
    }
    
    private func removeObservers(){
        viewModel.objSelectedBitcoinPriceInfo.removeObserver(self, forKeyPath: Constants.buyRateKeyPath)
        viewModel.objSelectedBitcoinPriceInfo.removeObserver(self, forKeyPath: Constants.sellRateKeyPath)
    }
    
    // MARK: - Observers
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
                if let path = keyPath, path == Constants.buyRateKeyPath {
                    strBuyRate = obj.buyRate
                }
                else if let path = keyPath, path == Constants.sellRateKeyPath {
                    strSellRate = obj.sellRate
                }
                print("object currency \(obj.currencyName)")
                print("object currency  id  \(obj.ID ?? 0)")
            }
        }
    }

}
