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
