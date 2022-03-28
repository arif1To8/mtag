//
//  VehicleDetailViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

enum VehicleDetailCellType: Int, CaseIterable {
    case carInfo = 0
    case transactionHistory = 1
    case seeMore = 2
    case carDetail = 3
}

class VehicleDetailViewController: UIViewController, Storyboarded, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var detail: MtagDetailsObject!
    var transactions: [TransactionObject] = []
    let maxTransactionLimit = 2
    let network = NetworkManager()
    let apiFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells()
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        collectionView.isHidden = true
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "car".localized()
        apiFormatter.dateFormat = "yyyy-MM-dd"
        getTransactionHistory(id: detail.tokenno ?? "", start: apiFormatter.string(from: Date() - TimeInterval(Constants.secondsInADay * 7)), end: apiFormatter.string(from: Date()))
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: VehicleDetailCarCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: VehicleDetailCarCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: TransactionHistoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TransactionHistoryCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: CarDetailCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CarDetailCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: SeeMoreCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SeeMoreCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: SeparatorHeaderCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SeparatorHeaderCollectionReusableView.identifier)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
    
}

extension VehicleDetailViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return VehicleDetailCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case VehicleDetailCellType.carInfo.rawValue:
            return 1
        case VehicleDetailCellType.transactionHistory.rawValue:
            if transactions.count > maxTransactionLimit {
                return maxTransactionLimit
            } else {
                return transactions.count
            }
        case VehicleDetailCellType.seeMore.rawValue:
            if transactions.count > maxTransactionLimit {
                return 1
            } else {
                return 0
            }
        case VehicleDetailCellType.carDetail.rawValue:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == VehicleDetailCellType.transactionHistory.rawValue {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SeparatorHeaderCollectionReusableView.identifier, for: indexPath) as! SeparatorHeaderCollectionReusableView
                headerView.frame.size.height = SeparatorHeaderCollectionReusableView.height()
                headerView.configure(titleText: "transactionHistory".localized())
                return headerView
            default:
                return UICollectionReusableView()
            }
        } else if indexPath.section == VehicleDetailCellType.carDetail.rawValue {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SeparatorHeaderCollectionReusableView.identifier, for: indexPath) as! SeparatorHeaderCollectionReusableView
                headerView.frame.size.height = SeparatorHeaderCollectionReusableView.height()
                headerView.configure(titleText: "carInformation".localized())
                return headerView
            default:
                return UICollectionReusableView()
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case VehicleDetailCellType.carInfo.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleDetailCarCollectionViewCell.identifier, for: indexPath) as! VehicleDetailCarCollectionViewCell
            cell.configure(carImageURL: "", mtagNumber: detail.tokenno ?? "", carModel: detail.registration ?? "", balance: detail.balance ?? "")
            cell.mtagDetailsObject = detail
            cell.showMtagRchargeViewController = {
                Router.showRechargeMtags(from: self, mtagDetailList: [self.detail], openFromVehicleDetail: true)
            }
            return cell
        case VehicleDetailCellType.transactionHistory.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransactionHistoryCollectionViewCell.identifier, for: indexPath) as! TransactionHistoryCollectionViewCell
            cell.configure(transaction: self.transactions[indexPath.row])
            return cell
        case VehicleDetailCellType.seeMore.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeMoreCollectionViewCell.identifier, for: indexPath) as! SeeMoreCollectionViewCell
            cell.configure(mtagId: detail.tokenno ?? "", action: {
                Router.showTransactionHistory(from: self, mtagDetailList: HomeScreenViewController.mtagDetailList, mtagID: self.detail.tokenno ?? "")
            })
            return cell
        case VehicleDetailCellType.carDetail.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarDetailCollectionViewCell.identifier, for: indexPath) as! CarDetailCollectionViewCell
            cell.configure(ownerName: detail.ownername ?? "N/A", regNum: detail.registration ?? "N/A", expiryDate: detail.expirydate ?? "N/A", vehicleType: detail.veh_type ?? "N/A")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == VehicleDetailCellType.transactionHistory.rawValue {
            if transactions.count > 0 {
                return CGSize(width: self.view.frame.size.width, height: SeparatorHeaderCollectionReusableView.height())
            } else {
                return CGSize(width: self.view.frame.size.width, height: 0)
            }
        } else if section == VehicleDetailCellType.carDetail.rawValue {
            return CGSize(width: self.view.frame.size.width, height: SeparatorHeaderCollectionReusableView.height())
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0.0
        switch indexPath.section {
        case VehicleDetailCellType.carInfo.rawValue:
            height = VehicleDetailCarCollectionViewCell.height()
        case VehicleDetailCellType.transactionHistory.rawValue:
            height = TransactionHistoryCollectionViewCell.height()
        case VehicleDetailCellType.seeMore.rawValue:
            height = SeeMoreCollectionViewCell.height()
        case VehicleDetailCellType.carDetail.rawValue:
            height = CarDetailCollectionViewCell.height()
        default:
            height = 0
        }
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
    
}

extension VehicleDetailViewController {
    func getTransactionHistory(id: String, start: String, end: String) {
        activityIndicator.startAnimating()
        network.request("getAllTrans",
                        method: .post,
                        parameters: ["mTagID":id,
                                     "pageNumber":1,
                                     "Start_Date":"",
                                     "End_Date":""],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: TransactionHistoryResponseModel.self,
                        success: { (response) in
                            if let response = response as? TransactionHistoryResponseModel {
                                if let transactionsList = response.Data?.AllTransactions {
                                self.transactions = transactionsList
                                }
                                self.collectionView.reloadData()
                                self.activityIndicator.stopAnimating()
                                self.collectionView.isHidden = false
                            }
                        },
                        failure: { (error) in
                            self.activityIndicator.stopAnimating()
                            self.collectionView.isHidden = false
                        })
    }
}
