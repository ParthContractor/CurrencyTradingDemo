//
//  CustomTextInputField.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 14/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class CustomTextInputField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
    }
    
    var isActive: Bool = false {
        willSet(newValue) {
            if newValue == true {
                layer.borderColor = UIColor.ThemeColor.selectedEnabledStateColor.cgColor
                layer.borderWidth = 1.5
            }
            else{
                layer.borderColor = UIColor.clear.cgColor
                layer.borderWidth = 0
            }
        }
    }
}
