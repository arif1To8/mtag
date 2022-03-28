//
//  HomeScreenViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

enum HomeScreenCellType: Int, CaseIterable {
    case empty = 0
    case buttons = 1
}

class HomeScreenViewController: UIViewController, Storyboarded, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let network = NetworkManager()
    static var mtagDetailList: [MtagDetailsObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells()
        setupUI()
        
        getCustomerDetail(openFeedback: false, doNothing: true)
        self.registerNotification()
        
    }
    override func viewWillAppear(_ animated: Bool) {

    

        if loginConstant.openFromLogin{
            loginConstant.openFromLogin = false
            self.checkVersions()
        }
    }
    
    
    
    
    func registerNotification(){
        
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.checkVersion),
            name: Notification.Name("checkVersionHome"),
            object: nil)
    }
    @objc private func checkVersion(notification: NSNotification){
        if !loginConstant.openFromLogin{
            self.checkVersions()
        }
        
    }
    

    func checkVersions(){
        //do stuff using the userInfo property of the notification object
        //        continueButton.showLoading()
        //                activityIndicator.startAnimating()
        //        continueButton.isEnabled = false
        network.request("VerCheck",
                        method: .post,
                        parameters: ["AppVer": Bundle.main.releaseVersionNumber ?? "1.1.2"],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept: HeaderConstants.acceptValue],
                        modelType: VersionCheck.self,
                        success: { (response) in
            self.activityIndicator.stopAnimating()
            if let versionResponse = response as? VersionCheck {
                print(versionResponse)
                if  let allowedCode = (versionResponse.code ?? "00") as? String{
                    if allowedCode != "00"{
                        DispatchQueue.main.async {
                            
                            Router.showUpdatePopUp(from: self, desc: versionResponse.message ?? "This Version is not allowed!")
                            
//                            Helper.showAlertWithOneButton("Update Required", message: versionResponse.message ?? "This Version is not allowed!", buttonTitle: "Update", controller: self) { actionn in
//                                Helper.moveToAppstore()
//                            }
                        }
                    }
                }
                
            }
            
        },
                        failure: { (error) in
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                Helper.showAlert("Alert", message: error?.localizedDescription ?? "Unknown error occured".localized(), controller: self)
                
            }
            
        })
    }
    
    
    
    func setupUI() {
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: HomeScreenButtonsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeScreenButtonsCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: HomeScreenProfileCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeScreenProfileCollectionReusableView.identifier)
    }
}

extension HomeScreenViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeScreenCellType.allCases.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == HomeScreenCellType.empty.rawValue {
            return 0
        } else {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if indexPath.section == HomeScreenCellType.empty.rawValue {
            switch kind {
              case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeScreenProfileCollectionReusableView.identifier, for: indexPath) as! HomeScreenProfileCollectionReusableView
                headerView.frame.size.height = HomeScreenProfileCollectionReusableView.height()
                return headerView
              default:
                break
              }
            }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case HomeScreenCellType.buttons.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenButtonsCollectionViewCell.identifier, for: indexPath) as! HomeScreenButtonsCollectionViewCell
            cell.configure(myMtagAction: {
                Router.showActiveMtags(from: self)
            }, tollHistoryAction: {
                Router.showTransactionHistory(from: self, mtagDetailList: HomeScreenViewController.mtagDetailList)
            }, pendingMtagAction: {
                Helper.showAlert("comingsoon".localized(), message: "comingSoonPending".localized(), controller: self)
                //self.getPendingMtagList()
            }, requestaction: {
                Helper.showAlert("comingsoon".localized(), message: "comingSoonRequest".localized(), controller: self)
                //self.getCustomerDetail(openFeedback: false)
            }, tollchargesAction: {
                self.getCustomerDetail(openFeedback: true)
            }, tollCalculatorAction: {
//                Helper.showAlert("comingsoon".localized(), message: "comingSoonMsg".localized(), controller: self)
                Router.showTollCalculator(from: self)
            }, helplineAction: {
                guard let number = URL(string: "tel://" + "1313") else { return }
                UIApplication.shared.open(number)
            }, rechargeAction: {
                Router.showRechargeMtags(from: self, mtagDetailList: HomeScreenViewController.mtagDetailList, openFromVehicleDetail: false)
            })
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == HomeScreenCellType.empty.rawValue {
            return CGSize(width: self.view.frame.size.width, height: HomeScreenProfileCollectionReusableView.height())
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0.0
        switch indexPath.section {
        case HomeScreenCellType.empty.rawValue:
            height = 0
        case HomeScreenCellType.buttons.rawValue:
            height = HomeScreenButtonsCollectionViewCell.height()
        default:
            height = 0
        }
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
}

extension HomeScreenViewController {
    
    func getActiveMtags() {
//        activityIndicator.startAnimating()
//        collectionView.isHidden = true
        self.collectionView.isUserInteractionEnabled = false
        network.request("getActiveMtags_new",
                        method: .post,
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: ActiveMtagResponseModel.self,
                        success: { (response) in
//                            self.collectionView.isHidden = false
//                            self.activityIndicator.stopAnimating()
            self.collectionView.isUserInteractionEnabled = true
                            if let response = response as? ActiveMtagResponseModel {
                                HomeScreenViewController.mtagDetailList = response.Data ?? []
                                self.collectionView.reloadData()
                            }
                        },
                        failure: { (error) in
            self.collectionView.isUserInteractionEnabled = true
//                            self.collectionView.isHidden = false
                            HomeScreenViewController.mtagDetailList = []
//                            self.activityIndicator.stopAnimating()
                        })
    }
    
        
    
    
    func getPendingMtagList() {
        activityIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
        network.request("getPendingMtags",
                        method: .post,
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: PendingMtagListResponseModel.self,
                        success: { (response) in
                            self.activityIndicator.stopAnimating()
                            self.collectionView.isUserInteractionEnabled = true
                            if let response = response as? PendingMtagListResponseModel {
                                if let list = response.Data?.Pending_MTAG_Detail {
                                    Router.showPendingMtagList(from: self, pendingMtagList: list)
                                }
                            }
                        },
                        failure: { (error) in
                            self.collectionView.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                            Router.showPendingMtagList(from: self, pendingMtagList: [])
                        })
    }
    
    func getCustomerDetail(openFeedback: Bool, doNothing: Bool = false) {
        if !doNothing {
//            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
        network.request("customerDetails",
                        method: .post,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: CustomerDetailResponseModel.self,
                        success: { (response) in
                            if !doNothing {
                                self.view.isUserInteractionEnabled = true
//                                self.activityIndicator.stopAnimating()
                            }
                            if let response = response as? CustomerDetailResponseModel {
                                if let userData = response.Data?.Customer_Detail {
                                    LocalStorage.saveUserInfoObject(userInfo: userData)
                                    if !doNothing {
                                        if openFeedback {
                                            //Router.showFeedbackList(from: self)
                                            Router.showFeedback(from: self)
                                        } else {
                                            Router.showMtagRequest(from: self)
                                        }
                                    } else {
                                        self.getActiveMtags()
                                    }
                                }
                            }
                            
                        },
                        failure: { (error) in
                            if !doNothing {
                                self.view.isUserInteractionEnabled = true
                                self.activityIndicator.stopAnimating()
                            }
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
                            
                        })
    }
}
