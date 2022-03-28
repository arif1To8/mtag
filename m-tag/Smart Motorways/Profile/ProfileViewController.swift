//
//  ProfileViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 09/06/2021.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ProfileViewController: UIViewController, Storyboarded {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var cnicTitle: UILabel!
    @IBOutlet weak var cnicValue: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var numberTitle: UILabel!
    @IBOutlet weak var logoutButton: LoadingButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var numberValue: UILabel!
    
    let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.textColor = ColorConstants.textBlack
        nameLabel.font = FontConstants.bold?.withSize(25)
        nameLabel.textColor = ColorConstants.textBlack
        
        cnicTitle.textColor = ColorConstants.textGray
        cnicTitle.font = FontConstants.regular?.withSize(14)
        cnicTitle.text = "cnicTitle".localized()
        
        cnicValue.textColor = ColorConstants.textBlack
        cnicValue.font = FontConstants.bold?.withSize(15)
        cnicValue.textColor = ColorConstants.textBlack
        
        numberTitle.textColor = ColorConstants.textGray
        numberTitle.font = FontConstants.regular?.withSize(14)
        numberTitle.text = "number".localized()
        
        numberValue.textColor = ColorConstants.textBlack
        numberValue.font = FontConstants.bold?.withSize(15)
        numberValue.textColor = ColorConstants.textBlack
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "profile".localized()
        
        logoutButton.backgroundColor = ColorConstants.orange
        logoutButton.setTitle("signout".localized(), for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.setTitleColor(ColorConstants.white, for: .normal)
        logoutButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        nameLabel.isHidden = true
        cnicValue.isHidden = true
        numberValue.isHidden = true
        cnicTitle.isHidden = true
        numberTitle.isHidden = true
        
        versionLabel.textColor = ColorConstants.silver
        versionLabel.font = FontConstants.regular?.withSize(10)
        poweredByLabel.textColor = ColorConstants.silver
        poweredByLabel.font = FontConstants.regular?.withSize(10)
        poweredByLabel.textAlignment = .center
        
        versionLabel.text = "version".localized() + (Bundle.main.releaseVersionNumber ?? "")
        poweredByLabel.text = "poweredBy".localized()
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        getCustomerDetail()
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        Helper.showAlertWithTwoButton("signout".localized(), message: "sureLogout".localized(), buttonTitleOne: "cancel".localized(), buttonTitleTwo: "yes".localized(), controller: self, handlerOne: nil, handlerTwo: {_ in
            self.logout()
        })
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
}

extension ProfileViewController {
    func logout() {
        logoutButton.showLoading()
        self.view.isUserInteractionEnabled = false
        network.request("logout",
                        method: .delete,
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: EmptyModel.self,
                        success: { (response) in
            self.logoutButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            LocalStorage.clearToken()
            HomeScreenViewController.mtagDetailList = []
            Router.showLoginAsRootVC()
        },
                        failure: { (error) in
            self.logoutButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
            
            
        })
    }
    
    func getCustomerDetail() {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        network.request("customerDetails",
                        method: .post,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: CustomerDetailResponseModel.self,
                        success: { (response) in
                            self.view.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                            if let response = response as? CustomerDetailResponseModel {
                                if let userData = response.Data?.Customer_Detail {
                                    self.nameLabel.text = userData.fullname
                                    self.numberValue.text = userData.mobileNumber
                                    self.cnicValue.text = userData.cnic
                                    self.nameLabel.isHidden = false
                                    self.cnicValue.isHidden = false
                                    self.numberValue.isHidden = false
                                    self.cnicTitle.isHidden = false
                                    self.numberTitle.isHidden = false
                                    LocalStorage.saveUserInfoObject(userInfo: userData)
                                }
                            }
                            
                        },
                        failure: { (error) in
                            self.view.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
                            
                        })
    }
}
