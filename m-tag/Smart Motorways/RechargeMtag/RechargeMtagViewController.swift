//
//  RechargeMtagViewController.swift
//  Smart Motorways
//
//  Created by Kaleem Asad on 11/25/21.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class RechargeMtagViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var rechargeByTitle: UILabel!
    @IBOutlet weak var noRecordLabel: UILabel!
    @IBOutlet weak var selectMtagLabel: UILabel!
    @IBOutlet weak var mtagPickerView: UIPickerView!
    @IBOutlet weak var preSelectedMtag: UILabel!
    @IBOutlet weak var mTagPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rechargeAmountLabel: UILabel!
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var preSelectedMtagHeight: NSLayoutConstraint!
    
    @IBOutlet weak var enterMTagField: UITextField!
    @IBOutlet weak var rechargeAmountField: UITextField!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    //    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    let network = NetworkManager()
    var mtagDetailList: [MtagDetailsObject] = []
    var selectedTagToken: String?
    var openFromVehicle = false
    
    private var rechargeByToggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "rechargeMtag".localized()
        //        activityIndicator.type = .circleStrokeSpin
        //        activityIndicator.color = ColorConstants.orange
        
        rechargeAmountField.delegate = self
        
        self.mtagPickerView.delegate = self
        self.mtagPickerView.dataSource = self
        
        proceedButton.layer.cornerRadius = 10
        
        
//        else if(self.mtagDetailList.count == 0){
//            Helper.showAlertWithOneButton("Error", message: "No Mtag availeble", buttonTitle: "OK", controller: self) { action in
//                self.backPressed(self)
//            }
//        }
        
        setupActivityIndicator()
        
//        setupInitialView()
        if self.openFromVehicle{
            self.setupInitialView()
        }else{
            getActiveMtags()
        }
        
        rechargeByTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rechargeByTitlePressed)))
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Router.pop(from: self)
    }
    @IBAction func proceedButtonPressed(_ sender: Any) {
        let amount = integer(from: rechargeAmountField)
        if (amount < 500 || amount > 10000){
//            Helper.showAlert("Recharge M-TAG", message: "Recharge ammount should be between PKR 500 and PKR 10,000", controller: self)
            Helper.showAlert("Recharge M-TAG", message: "Enter amount between 500 and 10,000.", controller: self)
        }
        else
        {
            if !rechargeByToggle {
                
//                self.selectedTagToken = mtagDetailList.first?.tokenno
                self.selectedTagToken = mtagDetailList[mtagPickerView.selectedRow(inComponent: 0)].tokenno
                rechargeCalc(with: amount)
            } else {
                if enterMTagField.text?.count == 8 {
                    self.selectedTagToken = enterMTagField.text
                    getOwnerName(with: amount)
                } else {
                    Helper.showAlert("Alert".localized(), message: "Please enter 8 digit M-TAG ID.", controller: self)
                }
            }
        }
    }
    
    func integer(from textField: UITextField) -> Int {
        guard let text = textField.text, let number = Int(text) else {
            return 0
        }
        return number
    }
    
    private func setupInitialView() {
        self.selectedTagToken = mtagDetailList.first?.tokenno
        
        if self.mtagDetailList.count == 1{
//            mtagPickerView.removeFromSuperview()
            mtagPickerView.isHidden = true
            enterMTagField.isHidden = true
            self.preSelectedMtag.text = mtagDetailList.first?.tokenno
            selectMtagLabel.text = "M-TAG ID"
        }
        else if(self.mtagDetailList.count > 1){
//            preSelectedMtag.removeFromSuperview()
            preSelectedMtag.isHidden = true
            enterMTagField.isHidden = true
        }
        
        if !mtagDetailList.isEmpty {
            rechargeByTitle.font = FontConstants.bold?.withSize(16)
            rechargeByTitle.textColor = ColorConstants.textGray
            rechargeByTitle.text = "RECHARGE OTHER"
        } else {
            rechargeByToggle = true
            rechargeByTitle.isHidden = true
            mtagPickerView.isHidden = true
            preSelectedMtag.isHidden = true
            enterMTagField.isHidden = false
            selectMtagLabel.text = "Enter M-TAG ID"
        }
    }
    
    @objc
    func rechargeByTitlePressed() {
        if rechargeByToggle {
            rechargeByTitle.text = "RECHARGE OTHER"
            if mtagDetailList.count == 1 {
                mtagPickerView.isHidden = true
                preSelectedMtag.isHidden = false
                selectMtagLabel.text = "M-TAG ID"
            } else if mtagDetailList.count > 1 {
                preSelectedMtag.isHidden = true
                mtagPickerView.isHidden = false
                selectMtagLabel.text = "Select M-Tag"
            }
            enterMTagField.isHidden = true
        } else {
            rechargeByTitle.text = "RECHARGE SELF"
            mtagPickerView.isHidden = true
            preSelectedMtag.isHidden = true
            enterMTagField.isHidden = false
            selectMtagLabel.text = "Enter M-TAG ID"
        }
        
        rechargeByToggle.toggle()
    }
    
    private func rechargeCalc(with amount: Int) {
        network.request("rechargeCalc",
                        method: .post,
                        parameters: ["amount":amount],
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: RechargeSummaryResponseModel.self,
                        success: { (response) in
                            //                                self.activityIndicator.stopAnimating()
                            if let response = response as? RechargeSummaryResponseModel {
                                if let data = response.data?.first {
                                    //Router.showFeedbackList(from: self)
                                    //                                        Router.showFeedback(from: self)
                                    
                                    Helper.showAlertWithTwoButton("Recharge Summary",
                                                                  message: """
                                        Charges,Taxes,FED = PKR \(data.charges_Taxes_FED ?? "0.0")
                                        M-Tag Balance = PKR \(data.m_Tag_Balance ?? "0.0")
                                        Total Recharge Amount = PKR \(data.total_Recharge_Amount ?? 0.0)
                                        
                                        Please proceed to continue
                                        """,
                                                                  buttonTitleOne: "Cancel",
                                                                  buttonTitleTwo: "Proceed",
                                                                  controller: self) { action1 in
                                        
                                     print("do nothing")
                                    } handlerTwo: { action2 in
                                        Router.showPaymentView(from: self, amount: "\(amount)", mTagToken: self.selectedTagToken ?? "NoTagToken")
                                    }
                                }
                            }
                        },
                        failure: { (error) in
                            //                                self.view.isUserInteractionEnabled = true
                            //                                self.activityIndicator.stopAnimating()
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
                            
                        })
    }
    
    private func getOwnerName(with amount: Int) {
        activityIndicator.startAnimating()
        containerView.isHidden = true
        network.request(
            "getOwnerName",
            method: .post,
            parameters: [
                "tokenno": enterMTagField.text ?? ""
            ],
            headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                      HeaderConstants.accept: HeaderConstants.acceptValue],
            modelType: GetOwnerNameModel.self,
            success: { response in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                
                if let response = response as? GetOwnerNameModel {
                    guard
                        let isActive = response.data?.first?.isActive,
                        let ownerName = response.data?.first?.ownerName
                    else { return }
                    
                    if isActive == "1" {
                        Helper.showAlertWithTwoButton(
                            "Owner Summary",
                            message: "Are you sure you want to recharge \(ownerName) with amount \(amount).",
                            buttonTitleOne: "Cancel",
                            buttonTitleTwo: "Next",
                            controller: self,
                            handlerOne: { _ in
                                self.dismiss(animated: true, completion: nil)
                            }, handlerTwo: { _ in
                                self.rechargeCalc(with: amount)
                            }
                        )
                    } else if isActive == "0" {
                        Helper.showAlert("Alert".localized(), message: "M-TAG \(self.enterMTagField.text ?? "--") has been blocked. Please call 1313 for further assistance.", controller: self)
                    }
                }
            },
            failure: { error in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                
                if (error?.code ?? 400) > 499 {
                    Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }else{
                    Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }


            }
        )
    }
    
    func getActiveMtags() {
        activityIndicator.startAnimating()
        containerView.isHidden = true
        network.request("getActiveMtags_new",
                        method: .post,
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: ActiveMtagResponseModel.self,
                        success: { (response) in
                            self.activityIndicator.stopAnimating()
                            self.containerView.isHidden = false
                            if let response = response as? ActiveMtagResponseModel {
                                self.mtagDetailList = response.Data ?? []
                                self.setupInitialView()
                            }
                        },
                        failure: { (error) in
                            self.activityIndicator.stopAnimating()
                            self.containerView.isHidden = false
                            self.mtagDetailList = []
                            self.setupInitialView()
                        })
    }
    
    func setupActivityIndicator() {
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
    }
}


extension RechargeMtagViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK - PickerView Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mtagDetailList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.mtagDetailList[row].tokenno
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected")
        self.selectedTagToken = self.mtagDetailList[row].tokenno
    }
    
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == rechargeAmountField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
}

extension RechargeMtagViewController: PaymentProtocol{
    func paymentResponse(controller: PaymentWebViewController,status: String, message: String) {
        //Do Something
        
        print("********payment responce method is called*******")
        
        controller.navigationController?.popViewController(animated: true)
        
        
        if (status == "success" && message == "Recharge Success"){
            Helper.showAlertWithOneButton("Recharge M-Tag", message: "Your M-Tag has been recharged successfully.", buttonTitle: "OK", controller: self) { action in
                self.backPressed(self)
            }
        }
        else if (status == "cancel" && message == "Payment cancelled") {
            Helper.showAlertWithOneButton("Recharge M-Tag", message: "Payment has been cancelled.", buttonTitle: "OK", controller: self) { _ in
            }
        }
        else if (status == "error" && message == "Payment timedout") {
            
            Helper.showAlertWithOneButton("Recharge M-Tag", message: "Payment Error", buttonTitle: "OK", controller: self) { action in
                self.backPressed(self)
            }
        }
        else {
            Helper.showAlertWithOneButton("Error", message: "Something went wrong while initialising payment gateway.", buttonTitle: "OK", controller: self) { action in
                self.backPressed(self)
            }
        }
    }
    
}
