//
//  LandingScreenVC.swift
//  CurrencyTradingDemo
//
//  Created by Parth on 11/12/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
extension UITableView {
func reloadWithAnimation() {
    self.reloadData()
    let tableViewHeight = self.bounds.size.height
    let cells = self.visibleCells
    var delayCounter = 0
    for cell in cells {
        cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
    }
    for cell in cells {
        UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        delayCounter += 1
    }
}
}
class LandingScreenVC: UIViewController {
        
    let viewModel = LandingScreenViewModel()

    @IBOutlet var tableViewBitcoinRateList: UITableView!

    // MARK: - ViewController LifeCycle
    init(nibName:String){
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        setUpData()
    }
    
    func initialSetUp(){
        tableViewBitcoinRateList.rowHeight = UITableView.automaticDimension
        tableViewBitcoinRateList.estimatedRowHeight = 80
        
        //tableview cell registeration
        tableViewBitcoinRateList.register(UINib(nibName: "BitcoinRateListCell", bundle: nil), forCellReuseIdentifier: BitcoinRateListCell.cellIdentifier)
        tableViewBitcoinRateList.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(initialBitcoinPriceInfoAvailable(_:)), name: .firstTimeBitcoinPriceInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(followUpPriceInfoAvailable), name: .followUpReloadPriceInfo, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods
    private func setUpData() {
        title = viewModel.navigationBarTitle
        viewModel.initialDataLoading()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.tableViewBitcoinRateList.reloadData()
        }
    }
    
    private func reloadVisibleData() {
           DispatchQueue.main.async {
               self.tableViewBitcoinRateList.reloadRows(at: self.tableViewBitcoinRateList.indexPathsForVisibleRows!, with: .none)
           }
    }
    
    private func reloadRow(_ row: Int) {
        self.tableViewBitcoinRateList.beginUpdates()
        let indexPath = NSIndexPath.init(row:  row, section: 0)
        self.tableViewBitcoinRateList.reloadRows(at: [indexPath as IndexPath], with: .none)
        self.tableViewBitcoinRateList.endUpdates()
    }
    
    // MARK: - Notification Observer
    @objc func initialBitcoinPriceInfoAvailable(_ notification: Notification)
    {
       //first time setup of price info arra done and hence add key value observers for objects..
        for objPriceInfo in PriceInfoProvider.shared.bitcoinPriceInfoArray {//make sure it is not being updated???
            objPriceInfo.addObserver(self, forKeyPath: "buyRate", options: [.new,.old], context: nil)
            objPriceInfo.addObserver(self, forKeyPath: "sellRate", options: [.new,.old], context: nil)
        }
        PriceInfoProvider.shared.sortByCurrencyName()
        reloadData()
    }
    
    @objc func followUpPriceInfoAvailable(_ notification: Notification)
    {
        DispatchQueue.main.async {
            self.reloadVisibleData()
        }
    }

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
                print("object currency \(obj.currencyName)")
                print("object currency  id  \(obj.ID ?? 0)")
//                if let id = obj.ID {
//                    reloadRow(id)
//                }
            }
        }
        
    }
}

extension LandingScreenVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Tableview delegate/datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PriceInfoProvider.shared.bitcoinPriceInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         cell.accessoryType = .disclosureIndicator
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BitcoinRateListCell.cellIdentifier) as! BitcoinRateListCell
        let objPrice = viewModel.priceInfoObjectAt(indexPath.row)
        let animation = viewModel.priceInfoBuyRateAnimationRequired(indexPath.row, oldBuyRateText: objPrice?.lastStoredBuyRate ?? "", oldSellRateText: objPrice?.lastStoredSellRate ?? "")
        cell.currencyLabel.text = viewModel.currencyLabelValue(indexPath.row)
        cell.accessibilityIdentifier = viewModel.currencyLabelValue(indexPath.row)
        cell.buyRateLabel.text =  viewModel.buyRateLabelValue(indexPath.row)
        cell.sellRateLabel.text = viewModel.sellRateLabelValue(indexPath.row)
        cell.animateLabelColor(animation)
        return cell
    }
    
}

