//
//  TransactionHistoryViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 28/06/2021.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class TransactionHistoryViewController: UIViewController, Storyboarded, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var noRecordsLabel: UILabel!
    @IBOutlet weak var dateRangeHeaderView: UIView!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var resetDateButton: UIButton!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let network = NetworkManager()
    //    var transactions: [String:[TransactionModel]] = [:]
    var transactions: [TransactionObject] = []
    var mtagDetailList: [MtagDetailsObject]!
    var mtagID = ""
    let apiFormatter = DateFormatter()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        apiFormatter.dateFormat = "yyyy-MM-dd"
        tableView.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "history".localized()
        
        noRecordsLabel.textColor = ColorConstants.textBlack
        noRecordsLabel.font = FontConstants.bold?.withSize(18)
        
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        tableViewTopConstraint.constant = 0
        dateRangeHeaderView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTransactionHistory(id: mtagID, start: "", end: "")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Router.pop(from: self)
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        Router.showHistoryFilterPopUp(from: self, mtags: mtagDetailList, callback: { [weak self] (start,end,mtag) in
            self?.transactions = []
            self?.getTransactionHistory(id: "", start: start, end: end)
            self?.tableViewTopConstraint.constant = 40
            self?.dateRangeHeaderView.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.date(from: start)
            let endDate = dateFormatter.date(from: end)
            dateFormatter.dateFormat = "dd/MM/yy"

            
            self?.dateRangeLabel.text = "\(dateFormatter.string(from: startDate ?? Date())) - \(dateFormatter.string(from: endDate ?? Date()))"
        })
    }
    @IBAction func resetDateAction(_ sender: Any) {
        tableViewTopConstraint.constant = 0
        dateRangeHeaderView.isHidden = true
        getTransactionHistory(id: mtagID, start: "", end: "")
    }
}

extension TransactionHistoryViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        let keys = Array(transactions.keys)
        //        return keys.count
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let keys = Array(transactions.keys)
        //        return transactions[keys[section]]?.count ?? 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let keys = Array(transactions.keys)
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        
        //        let record = transactions[keys[indexPath.section]]?[indexPath.row]
        cell.configure(transaction: transactions[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HistoryTableViewCell.height()
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let keys = Array(transactions.keys)
    //        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
    //        headerView.backgroundColor = ColorConstants.white
    //        headerView.layer.cornerRadius = 35
    //        let label = UILabel()
    //        label.frame = CGRect.init(x: 30, y: 10, width: headerView.frame.width / 2, height: headerView.frame.height-10)
    //        label.text = "mtag".localized() + " " + keys[section]
    //        label.font = FontConstants.bold?.withSize(16)
    //        label.textColor = ColorConstants.orange
    //        headerView.addSubview(label)
    //        return headerView
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 50
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 40
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
    //        footerView.backgroundColor = .clear
    //        return footerView
    //    }
    
}

extension TransactionHistoryViewController {
    
    func getTransactionHistory(id: String, start: String, end: String) {
        self.activityIndicator.startAnimating()
        self.tableView.isHidden = true
        network.request("getAllTrans",
                        method: .post,
                        parameters: ["mTagID":id,
                                     "pageNumber":1,
                                     "Start_Date":start,
                                     "End_Date":end],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: TransactionHistoryResponseModel.self,
                        success: { (response) in
                            print("PAPi")
                            print(response)
                            
                            var count1 = 0
                            var count2 = 0
                            if let response = response as? TransactionHistoryResponseModel {
                                if let recharges = response.Data?.AllTransactions {
                                    
                                    if recharges.count > 0{
                                        self.transactions = recharges
                                        self.tableView.isHidden = false
                                        self.noRecordsLabel.isHidden = true
                                        self.tableView.reloadData()
                                    }
                                    else{
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let startDate = dateFormatter.date(from: start)
                                        let endDate = dateFormatter.date(from: end)
                                        dateFormatter.dateFormat = "dd-MM-yyyy"
                                        self.noRecordsLabel.isHidden = false
                                        self.noRecordsLabel.text = "noRecordAvailable".localized()
                                        
                                    }
                                    
                                    //                                    for recharge in recharges {
                                    //                                        let record = TransactionModel(type: .recharge, city: recharge.RECHARGESTATION ?? "", date: recharge.TRANS_TIME ?? "", amount: Int(recharge.FARE ?? "0") ?? 0)
                                    //                                        if self.transactions[recharge.MTAG_ID ?? ""] == nil {
                                    //                                            self.transactions[recharge.MTAG_ID ?? ""] = [record]
                                    //                                        } else {
                                    //                                            self.transactions[recharge.MTAG_ID ?? ""]?.append(record)
                                    //                                        }
                                    //                                    }
                                    //                                    count1 = recharges.count
                                }
                                //                                if let tolls = response.Data?.TollTransactions {
                                //                                    for toll in tolls {
                                //                                        let record = TransactionModel(type: .payment, city: (toll.ENTRY_STATION_NAME ?? "") + " - " + (toll.EXIT_STATION_NAME ?? ""), date: toll.TRANS_TIME ?? "", amount: Int(toll.FARE ?? "0") ?? 0)
                                //                                        if self.transactions[toll.MTAG_ID ?? ""] == nil {
                                //                                            self.transactions[toll.MTAG_ID ?? ""] = [record]
                                //                                        } else {
                                //                                            self.transactions[toll.MTAG_ID ?? ""]?.append(record)
                                //                                        }
                                //                                    }
                                //                                    count2 = tolls.count
                                //                                }
                                //                                if count1 == 0 && count2 == 0 {
                                //                                    let dateFormatter = DateFormatter()
                                //                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                //                                    let startDate = dateFormatter.date(from: start)
                                //                                    let endDate = dateFormatter.date(from: end)
                                //                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                //                                    self.noRecordsLabel.isHidden = false
                                //                                    self.noRecordsLabel.text = "noRecordAvailable".localized()
                                //                                } else {
                                //                                    self.tableView.isHidden = false
                                //                                    self.noRecordsLabel.isHidden = true
                                //                                    self.tableView.reloadData()
                                //                                }
                            }
                            self.view.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                        },
                        failure: { (error) in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let startDate = dateFormatter.date(from: start)
                            let endDate = dateFormatter.date(from: end)
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            self.noRecordsLabel.isHidden = false
                            self.noRecordsLabel.text = "noRecordAvailable".localized()
                            self.tableView.reloadData()
                            self.view.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                            self.tableView.isHidden = false
                        })
    }
}
