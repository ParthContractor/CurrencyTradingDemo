//
//  UIViewControllerExtensions.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//


import UIKit

//TODO: To be optimised
var loadingIndicatorView : UIView?//extensions can not containe stored property hence temporary workaround for utilising reusable loading indicator through extension

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
          view.endEditing(true)
    }
    
    func isNumberValidWithTwoDecimalPoints(_ textString: String?, range: NSRange, replacementString: String) -> Bool {
        guard let oldText = textString, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: replacementString)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }

    func presentAlert(withTitle title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showLoadingIndicator(onView : UIView) {
        let loadingView = UIView.init(frame: onView.bounds)
        let ai: UIActivityIndicatorView!
        ai = UIActivityIndicatorView.init(style: .gray)
        ai.backgroundColor = .red
        ai.startAnimating()
        ai.center = loadingView.center
        
        DispatchQueue.main.async {
            loadingView.addSubview(ai)
            onView.addSubview(loadingView)
        }
        
        loadingIndicatorView = loadingView
    }
    
    func removeLoadingIndicator() {
        DispatchQueue.main.async {
            loadingIndicatorView?.removeFromSuperview()
            loadingIndicatorView = nil
        }
    }
}
