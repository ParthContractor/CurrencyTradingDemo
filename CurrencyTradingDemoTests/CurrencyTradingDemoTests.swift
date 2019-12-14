//
//  CurrencyTradingDemoTests.swift
//  CurrencyTradingDemoTests
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import XCTest
@testable import CurrencyTradingDemo

class CurrencyTradingDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLandingScreenViewModelInit(){
          let viewModel = LandingScreenViewModel()
          XCTAssertNotNil(viewModel.navigationBarTitle)
          XCTAssertEqual(viewModel.navigationBarTitle,"Bitcoin Trading")
    }
    
    func testBitcoinPriceInfo() {
        let bitcoinPriceInfo1 = BitcoinPriceInfo(currencyName: "USD", buyRate: "232.09", sellRate: "245.09", symbol: "$")
        let bitcoinPriceInfo2 = BitcoinPriceInfo(currencyName: "AUD", buyRate: "232.09", sellRate: "245.09", symbol: "$")
        XCTAssertNotEqual(bitcoinPriceInfo1,bitcoinPriceInfo2)
        let bitcoinPriceInfo3 = BitcoinPriceInfo(currencyName: "AUD", buyRate: "232.09", sellRate: "245.09", symbol: "$")
        XCTAssertEqual(bitcoinPriceInfo2,bitcoinPriceInfo3)
        XCTAssertNil(bitcoinPriceInfo2.lastStoredSellRate)
        XCTAssertNil(bitcoinPriceInfo2.lastStoredBuyRate)
    }
    
    func testArraySafeIndex() {
        let arr = [1,2,3,6,78]
        let obj = arr[safeIndex: 10]
        XCTAssertNil(obj)
        let obj2 = arr[safeIndex: 2]
        XCTAssertNotNil(obj2)
        XCTAssertEqual(obj2!,3)
    }

    func testDoubleNumberRoundWithSpecificDecimalPoints() {
        let doubleNum = 234455.98445533
        let rounedString = doubleNum.roundedStringValue(to: 3)
        XCTAssertNotNil(rounedString)
        XCTAssertEqual(rounedString, "234455.984")
        XCTAssertNotEqual(rounedString, "234455.98445533")
    }
    
    func testGetFunctionAPIUtility() {
        let request = NSMutableURLRequest(url: URL(string: Constants.APIConstants.bitcoinPriceInfoURL)!)
        let exp = expectation(description: "GetFunctionAPIUtility")
        
        APIUtility.get(request: request) { (success, returnObject) -> () in
            DispatchQueue.main.async {
                if success {
                    guard let data = returnObject.1 else { return }
                    let containerData = try? JSONDecoder().decode(Containers.self, from: data)
                    if let priceData = containerData {
                        XCTAssertGreaterThan(priceData.inner.count, 0)
                        XCTAssertEqual(priceData.inner.count, 22)
                    }
                    exp.fulfill()
                } else {
                    exp.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 7)
    }
    
    func testCustomButton() {
       let btn = CustomButton(type: .custom)
       btn.isEnabled = false
       XCTAssertNotEqual(btn.alpha,1.0)
       btn.isEnabled = true
       XCTAssertEqual(btn.alpha,1.0)
    }
    
    func testCustomTextInputField() {
        let textField = CustomTextInputField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        textField.isActive = true
        XCTAssertNotEqual(textField.layer.borderWidth,0.0)
        textField.isActive = false
        XCTAssertEqual(textField.layer.borderWidth,0.0)
    }
}
