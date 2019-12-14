//
//  CustomButton.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 14/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.ThemeColor.selectedEnabledStateColor
        self.titleLabel?.textColor = .white
    }
    
    override var isEnabled: Bool {
        didSet {
            if (self.isEnabled == false) {
                self.alpha = 0.60
                self.isUserInteractionEnabled = false
            } else {
                self.alpha = 1.0
                self.isUserInteractionEnabled = true
            }
        }
    }
}
