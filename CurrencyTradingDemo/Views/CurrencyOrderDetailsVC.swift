//
//  CurrencyOrderDetailsVC.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 13/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

enum Market {
    case Buy
    case Sell
}
class CurrencyOrderDetailsVC: UIViewController {
    
    let viewModel: CurrencyOrderDetailsViewModel
    
    var marketSelected: Market = .Sell {
        didSet {
            if marketSelected == .Sell {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SELL-Market", style: .plain, target: self, action: nil)
            }
            else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "BUY-Market", style: .plain, target: self, action: nil)
            }
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBOutlet var lblBUY: UILabel!{
        didSet {
            lblBUY.font = UIFont.tinyInformationFont
            lblBUY.textColor = .white
        }
    }
    @IBOutlet var lblSELL: UILabel!{
        didSet {
            lblSELL.font = UIFont.tinyInformationFont
            lblSELL.textColor = .white
        }
    }
    @IBOutlet var btnBuyRatePanel: UIButton!{
        didSet{
            btnBuyRatePanel.isSelected = false
            btnBuyRatePanel.backgroundColor = .clear
        }
    }
    @IBOutlet var btnSellRatePanel: UIButton!{
        didSet{
            btnSellRatePanel.isSelected = true
            btnSellRatePanel.backgroundColor = .clear
        }
    }

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var stackViewBottomOrderButtons: UIStackView!
    @IBOutlet var lblBuyRate: BuySellRateLabel!
    @IBOutlet var lblSellRate: BuySellRateLabel!
    @IBOutlet var lblSpreadCalculation: UILabel!{
        didSet {
            lblSpreadCalculation.font = UIFont.tinyInformationFont
            lblSpreadCalculation.textColor = .white
        }
    }
        
    private var strBuyRate: String! {
        didSet {
            let animationRequired = viewModel.priceInfoBuyRateAnimationRequired(oldBuyRateText: lblBuyRate.lastStoredText)
            if animationRequired == true {
                UIView.transition(with: lblBuyRate, duration: 0.8, options: .transitionCrossDissolve, animations: {
                    self.lblBuyRate.customText = self.strBuyRate
                    self.lblBuyRate.textColor = UIColor.green
                }, completion: { _ in
                    self.lblBuyRate.textColor = .white
                    self.lblBuyRate.lastStoredText = self.strBuyRate
                    self.spreadCalculation()
                })
            }
            else{
                lblBuyRate.customText = strBuyRate
                spreadCalculation()
            }
        }
    }

    private var strSellRate: String! {
        didSet {
            let animationRequired = viewModel.priceInfoSellRateAnimationRequired(oldSellRateText: lblSellRate.lastStoredText)
            if animationRequired == true {
                UIView.transition(with: lblSellRate, duration: 0.8, options: .transitionCrossDissolve, animations: {
                    self.lblSellRate.customText = self.strSellRate
                    self.lblSellRate.textColor = UIColor.green
                }, completion: { _ in
                    self.lblSellRate.textColor = .white
                    self.lblSellRate.lastStoredText = self.strSellRate
                    self.spreadCalculation()
                })
            }
            else{
                lblSellRate.customText = strSellRate
                spreadCalculation()
            }
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
        initialSetUp()
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
        guard marketSelected == .Buy else {
            return
        }
        sellPanelSelectedState()
    }
    
    @IBAction func btnBuyPanelTapped(_ sender: UIButton) {
        guard marketSelected == .Sell else {
            return
        }
        buyPanelSelectedState()
    }
    
    // MARK: - Helpers
    private func initialSetUp(){
           stackViewBottomOrderButtons.setCustomSpacing(10.0, after: btnCancel)
           navigationItem.setHidesBackButton(true, animated:true)
           sellPanelSelectedState()
    }
    
    private func setUpData(){
        strBuyRate = viewModel.objSelectedBitcoinPriceInfo.buyRate
        strSellRate = viewModel.objSelectedBitcoinPriceInfo.sellRate
        title = viewModel.navigationTitle
        marketSelected = .Sell
    }
    
    private func sellPanelSelectedState(){
        marketSelected = .Sell
        btnBuyRatePanel.isSelected = false
        btnSellRatePanel.isSelected = true
        lblBuyRate.backgroundColor = .clear
        lblSellRate.backgroundColor = UIColor.ThemeColor.selectedEnabledStateColor
    }
    
    private func buyPanelSelectedState(){
        marketSelected = .Buy
        btnBuyRatePanel.isSelected = true
        btnSellRatePanel.isSelected = false
        lblBuyRate.backgroundColor = UIColor.ThemeColor.selectedEnabledStateColor
        lblSellRate.backgroundColor = .clear
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
