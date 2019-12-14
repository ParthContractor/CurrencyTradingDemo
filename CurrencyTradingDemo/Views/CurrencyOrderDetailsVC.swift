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
            autoSetupAmountTextField(textFieldUnits.text)
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
    @IBOutlet var lblUnits: UILabel!{
        didSet {
            lblUnits.font = UIFont.tinyInformationFont
            lblUnits.textColor = UIColor.ThemeColor.selectedEnabledStateColor
        }
    }
    @IBOutlet var textFieldUnits: CustomTextInputField!{
        didSet {
            textFieldUnits.isActive = false
        }
    }
    @IBOutlet var textFieldAmount: CustomTextInputField!{
        didSet {
            textFieldAmount.isActive = false
        }
    }
    @IBOutlet var lblAmount: UILabel!{
        didSet {
            lblAmount.font = UIFont.tinyInformationFont
            lblAmount.textColor = UIColor.ThemeColor.selectedEnabledStateColor
        }
    }
    @IBOutlet var btnBuyRatePanel: UIButton!{
        didSet{
            btnBuyRatePanel.isSelected = false
            btnBuyRatePanel.backgroundColor = .clear
            btnBuyRatePanel.layer.borderColor = UIColor.lightText.cgColor
            btnBuyRatePanel.layer.borderWidth = 1
        }
    }
    @IBOutlet var btnSellRatePanel: UIButton!{
        didSet{
            btnSellRatePanel.isSelected = true
            btnSellRatePanel.backgroundColor = .clear
            btnSellRatePanel.layer.borderColor = UIColor.lightText.cgColor
            btnSellRatePanel.layer.borderWidth = 1
        }
    }

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnConfirm: CustomButton!{
        didSet{
            btnConfirm.isEnabled = false
        }
    }
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
                UIView.transition(with: lblBuyRate, duration: 1.0, options: .transitionCrossDissolve, animations: {
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
            autoSetupAmountTextField(textFieldUnits.text)
        }
    }

    private var strSellRate: String! {
        didSet {
            let animationRequired = viewModel.priceInfoSellRateAnimationRequired(oldSellRateText: lblSellRate.lastStoredText)
            if animationRequired == true {
                UIView.transition(with: lblSellRate, duration: 1.0, options: .transitionCrossDissolve, animations: {
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
            autoSetupAmountTextField(textFieldUnits.text)
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnConfirmTapped(_ sender: UIButton) {
        presentAlert(withTitle: "Bitcoin Trading", message: "Order feature needs to be implemented..")
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
    
    @objc func textFieldDidChange(textField: UITextField){
        if textField.tag == 1 {
            autoSetupAmountTextField(textFieldUnits.text)
        }
        else{
            autoSetupUnitsTextField(textFieldAmount.text)
        }
        btnConfirmStateSetup()
    }
    
    // MARK: - Helpers
    private func initialSetUp(){
        stackViewBottomOrderButtons.setCustomSpacing(10.0, after: btnCancel)
        navigationItem.setHidesBackButton(true, animated:true)
        sellPanelSelectedState()
        hideKeyboardWhenTappedAround()
        textFieldAmount.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textFieldUnits.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        textFieldAmount.delegate = self
        textFieldAmount.keyboardType = .decimalPad
        textFieldUnits.delegate = self
        textFieldUnits.keyboardType = .decimalPad
    }
    
    private func setUpData(){
        strBuyRate = viewModel.objSelectedBitcoinPriceInfo.buyRate
        strSellRate = viewModel.objSelectedBitcoinPriceInfo.sellRate
        title = viewModel.navigationTitle
        marketSelected = .Sell
        lblAmount.text = viewModel.lblAmountValue
    }
    
    private func autoSetupAmountTextField(_ strUnits: String?){
        guard let numOfUnitsString = strUnits, numOfUnitsString.count != 0  else {
            textFieldAmount.text = ""
            return
        }
        let doubleUnits = Double(numOfUnitsString)
        var doubleRate: Double!
        if marketSelected == .Buy {
            doubleRate = Double(strBuyRate)
        }
        else{
            doubleRate = Double(strSellRate)
        }
        if let units = doubleUnits, let rate = doubleRate {
            let amountCalculated = units * rate
            textFieldAmount.text = amountCalculated.roundedStringValue(to: 2)
        }
    }
    
    private func autoSetupUnitsTextField(_ strAmount: String?){
           guard let amountString = strAmount, amountString.count != 0  else {
               textFieldUnits.text = ""
               return
           }
           let doubleAmount = Double(amountString)
           var doubleRate: Double!
           if marketSelected == .Buy {
               doubleRate = Double(strBuyRate)
           }
           else{
               doubleRate = Double(strSellRate)
           }
           if let amount = doubleAmount, let rate = doubleRate {
               let unitsCalculated = amount / rate
               textFieldUnits.text = unitsCalculated.roundedStringValue(to: 2)
           }
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
    
    private func btnConfirmStateSetup(){
        if textFieldUnits.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 ||  textFieldAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
            btnConfirm.isEnabled = true
        }
        else{
            btnConfirm.isEnabled = false
        }
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
        
        if let _ = change[.newKey]  {
            if object is BitcoinPriceInfo {
                let obj = object as! BitcoinPriceInfo
                if let path = keyPath, path == Constants.buyRateKeyPath {
                    strBuyRate = obj.buyRate
                }
                else if let path = keyPath, path == Constants.sellRateKeyPath {
                    strSellRate = obj.sellRate
                }
            }
        }
    }

}

extension CurrencyOrderDetailsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isNumberValidWithTwoDecimalPoints(textField.text, range: range, replacementString: string)
    }
    
}
