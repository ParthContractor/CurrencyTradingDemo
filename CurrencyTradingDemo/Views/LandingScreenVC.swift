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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initialSetUp(){
        tableViewBitcoinRateList.rowHeight = UITableView.automaticDimension
        tableViewBitcoinRateList.estimatedRowHeight = 126
        
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
        let indexPath = NSIndexPath.init(row:  row, section: 0)
        DispatchQueue.main.async {
            self.tableViewBitcoinRateList.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
    
    // MARK: - Observers
    @objc func initialBitcoinPriceInfoAvailable(_ notification: Notification)
    {
        PriceInfoProvider.shared.sortByCurrencyName()
        reloadData()
    }
    
    //TODO: To be optimised--Simultaneous cell reloading and animation within its rate labels user expeience improvement.
    @objc func followUpPriceInfoAvailable(_ notification: Notification)
    {
//        self.reloadRow(3)
//        return
        var after = 0.0
        for cell in self.tableViewBitcoinRateList.visibleCells {
            let indexPath: IndexPath = self.tableViewBitcoinRateList.indexPath(for: cell)!
                 DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                    after = after + 0.5
                    self.reloadRow(indexPath.row)
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
         cell.tintColor = .white
         let image = UIImage(named:"IndicatorArrow")?.withRenderingMode(.alwaysTemplate)
             let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
         disclosureImageView.image = image
         cell.accessoryView = disclosureImageView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BitcoinRateListCell.cellIdentifier) as! BitcoinRateListCell
        let objPrice = viewModel.priceInfoObjectAt(indexPath.row)
        let animation = viewModel.priceInfoRateAnimationRequired(indexPath.row, oldBuyRateText: objPrice?.lastStoredBuyRate ?? "", oldSellRateText: objPrice?.lastStoredSellRate ?? "")
        cell.currencyLabel.text = viewModel.currencyLabelValue(indexPath.row)
        cell.accessibilityIdentifier = viewModel.currencyLabelValue(indexPath.row)
        cell.animateLabelColor(animation, buyRateLabelValue: viewModel.buyRateLabelValue(indexPath.row), sellRateLabelValue: viewModel.sellRateLabelValue(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let objSelectedPriceInfo = PriceInfoProvider.shared.bitcoinPriceInfoArray[indexPath.row]
        let viewModel = CurrencyOrderDetailsViewModel(objSelectedPriceInfo)
        let currencyOrderDetailsVC = CurrencyOrderDetailsVC(nibName: "CurrencyOrderDetailsVC", viewModel: viewModel)
        navigationController?.pushViewController(currencyOrderDetailsVC, animated:true)
    }
    
}

