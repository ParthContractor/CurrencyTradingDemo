//
//  ArrayExtension.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 12/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
