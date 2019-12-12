//
//  LandingScreenVC.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class LandingScreenVC: UIViewController {
        
    let viewModel = LandingScreenViewModel()
        
    // MARK: - ViewController LifeCycle
    init(nibName:String){
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Helper methods
    private func setUpData() {
        title = viewModel.navigationBarTitle
    }

}
