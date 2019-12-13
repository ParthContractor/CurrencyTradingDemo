//
//  BitcoinRateListCell.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class BitcoinRateListCell: UITableViewCell {

    static let cellIdentifier = "BitcoinRateListCellId"
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var buyRateLabel: UILabel!
    @IBOutlet var sellRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        decorateCurrencyLabel()
        decorateBuyRateLabel()
        decorateSellRateLabel()
    }
    
    private func decorateCurrencyLabel()  {
        currencyLabel.adjustsFontSizeToFitWidth = false
        currencyLabel.font = UIFont.ThemeFont.currencyRatesListTitleFont
        currencyLabel.textColor = UIColor.ThemeColor.currencyNameDisplayColor
    }
    
    private func decorateBuyRateLabel()  {
        buyRateLabel.adjustsFontSizeToFitWidth = false
        buyRateLabel.font = UIFont.ThemeFont.currencyRatesListDetailFont
        buyRateLabel.textColor = UIColor.ThemeColor.currencyBuyRateColor
    }
    
    private func decorateSellRateLabel()  {
        sellRateLabel.adjustsFontSizeToFitWidth = false
        sellRateLabel.font = UIFont.ThemeFont.currencyRatesListDetailFont
        sellRateLabel.textColor = UIColor.ThemeColor.currencyBuyRateColor
    }
    
    func animateLabelColor(_ animation: (Bool,Bool), buyRateLabelValue: String, sellRateLabelValue: String){
        if animation.0 == true {
            UIView.transition(with: buyRateLabel, duration: 0.8, options: .transitionCrossDissolve, animations: {
                self.buyRateLabel.text = buyRateLabelValue
                self.buyRateLabel.textColor = UIColor.red
            }, completion: { _ in
                self.buyRateLabel.textColor = UIColor.ThemeColor.currencyBuyRateColor
                if animation.1 == true {
                    UIView.transition(with: self.sellRateLabel, duration: 0.8, options: .transitionCrossDissolve, animations: {
                        self.sellRateLabel.text = sellRateLabelValue
                        self.sellRateLabel.textColor = UIColor.green
                    }, completion: { _ in
                        self.sellRateLabel.textColor = UIColor.ThemeColor.currencyBuyRateColor
                    })
                }
            })
        }
        else{
            self.buyRateLabel.text = buyRateLabelValue
            self.sellRateLabel.text = sellRateLabelValue
        }
    }

}
