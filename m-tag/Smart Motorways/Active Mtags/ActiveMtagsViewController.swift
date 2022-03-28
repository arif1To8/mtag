//
//  ActiveMtagsViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 28/06/2021.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

protocol gettingPermissionForDlink {
    func getReasonAndConfirmation(msg: String)
}

class ActiveMtagsViewController: UIViewController, Storyboarded {

//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var noRecordLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var mtagDetailList: [MtagDetailsObject] = []
    let network = NetworkManager()
    
    var objProtocol: gettingPermissionForDlink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "myMtag".localized()
        registerCells()
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        noRecordLabel.textColor = ColorConstants.textBlack
        noRecordLabel.font = FontConstants.bold?.withSize(18)
        noRecordLabel.text = "noRecordAvailable".localized()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getActiveMtags()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Router.pop(from: self)
    }
    
    func registerCells() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: activeMtagTblCell.identifier, bundle: nil), forCellReuseIdentifier: activeMtagTblCell.identifier)
    }
    
    func getActiveMtags() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        network.request("getActiveMtags_new",
                        method: .post,
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: ActiveMtagResponseModel.self,
                        success: { (response) in
                            self.tableView.isHidden = false
                            self.activityIndicator.stopAnimating()
                            if let response = response as? ActiveMtagResponseModel {
                                self.mtagDetailList = response.Data ?? []
                                self.tableView.reloadData()
                            }
                        },
                        failure: { (error) in
                            self.tableView.isHidden = false
                            self.mtagDetailList = []
                            self.activityIndicator.stopAnimating()
                            if self.mtagDetailList.isEmpty {
                                self.noRecordLabel.isHidden = false
                            }
                        })
    }
}

extension ActiveMtagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        let keys = Array(transactions.keys)
        //        return keys.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let keys = Array(transactions.keys)
        //        return transactions[keys[section]]?.count ?? 0
        return mtagDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let keys = Array(transactions.keys)
        let cell = tableView.dequeueReusableCell(withIdentifier: activeMtagTblCell.identifier, for: indexPath) as! activeMtagTblCell
        
        cell.configure(carImageURL: "", mtagNumber: mtagDetailList[indexPath.row].tokenno ?? "", carModel: mtagDetailList[indexPath.row].registration ?? "", balance: mtagDetailList[indexPath.row].balance ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return activeMtagTblCell.height()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mtagDetailList.count > 0{
            if indexPath.row < self.mtagDetailList.count{
                Router.showVehicleDetail(from: self, detail: mtagDetailList[indexPath.row])
            }
        }
        
        
    }
    
    
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
//
//        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Delete" , handler: { [self] (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
//            print("")
//            Router.showDelinkActiveTagPopUp(from: self,  mtagDetailObj: mtagDetailList[indexPath.row]) { msg, obj in
//                print(obj)
//            }
//
//           })
//           return [deleteAction]
//
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete{
//            print("delete button is pressed")
//            Router.showDelinkActiveTagPopUp(from: self, desc: """
//                                            Are you sure to delink this vehicle
//                                            M-Tag: \(mtagDetailList[indexPath.row].tokenno ?? "")
//                                            Model: \(mtagDetailList[indexPath.row].registration ?? "")
//                                            """)
//
//        }
//    }
    
    


    
    
    
//    previously was handled by colletion view
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return mtagDetailList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MtagCollectionViewCell.identifier, for: indexPath) as! MtagCollectionViewCell
//        cell.configure(carImageURL: "", mtagNumber: mtagDetailList[indexPath.row].tokenno ?? "", carModel: mtagDetailList[indexPath.row].registration ?? "", balance: mtagDetailList[indexPath.row].balance ?? "")
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: MtagCollectionViewCell.height())
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Router.showVehicleDetail(from: self, detail: mtagDetailList[indexPath.row])
//    }
}












//extension ActiveMtagsViewController {
//    func getMtagDetail(id: String, carImageUrl: String) {
//        self.view.isUserInteractionEnabled = false
//        self.activityIndicator.startAnimating()
//        network.request("getMtagDetailByID?",
//                        method: .post,
//                        parameters: ["mTagID":id],
//                        encoding: JSONEncoding.default,
//                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
//                                  HeaderConstants.accept:HeaderConstants.acceptValue],
//                        modelType: MtagDetailResponse.self,
//                        success: { (response) in
//                            self.view.isUserInteractionEnabled = true
//                            self.activityIndicator.stopAnimating()
//                            if let response = response as? MtagDetailResponse {
//                                var transactions: [TransactionModel] = []
//                                if let recharges = response.Data?.TagDetail?.Transactions?.Recharge {
//                                    for recharge in recharges {
//                                        transactions.append(TransactionModel(type: .recharge, city: recharge.RECHARGESTATION ?? "", date: recharge.DATETIME ?? "", amount: Int(recharge.AMOUNT ?? 0)))
//                                    }
//                                }
//                                if let tolls = response.Data?.TagDetail?.Transactions?.Toll {
//                                    for toll in tolls {
//                                        transactions.append(TransactionModel(type: .payment, city: (toll.ENTRY_STATION_NAME ?? "") + " - " + (toll.EXIT_STATION_NAME ?? ""), date: toll.CREATEDAT ?? "", amount: Int(toll.TOLL ?? 0)))
//                                    }
//                                }
//                                //Router.showVehicleDetail(from: self, detail: response, transactions: transactions, carImageUrl: carImageUrl)
//                            }
//                        },
//                        failure: { (error) in
//                            self.view.isUserInteractionEnabled = true
//                            self.activityIndicator.stopAnimating()
//                            Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
//                        })
//    }
//}
