//
//  RegisterViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 27/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class RegisterViewController: UIViewController, Storyboarded, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var cnicField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstnameField: SkyFloatingLabelTextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var continueButton: LoadingButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var screenTitle: UILabel!
    
    let network = NetworkManager()
    var titleFormatter = { (text: String) -> String in
        return text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cnicField.delegate = self
        mobileField.delegate = self
        
        firstnameField.placeholder = "fullname".localized()
        firstnameField.font = FontConstants.bold?.withSize(16)
        firstnameField.textColor = ColorConstants.textBlack
        firstnameField.selectedTitleColor = ColorConstants.orange
        firstnameField.selectedLineColor = ColorConstants.orange
        firstnameField.titleFormatter = titleFormatter
        
        mobileField.font = FontConstants.bold?.withSize(16)
        mobileField.textColor = ColorConstants.textBlack
        mobileField.selectedTitleColor = ColorConstants.orange
        mobileField.selectedLineColor = ColorConstants.orange
        mobileField.titleFormatter = titleFormatter
        mobileField.title = "mobile".localized()
        mobileField.placeholder = "mobile".localized()
        
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: mobileField.frame.size.height))
//        let code = UILabel(frame: CGRect(x: 0, y: 16, width: 20, height: 20))
//        code.text = mobilePreFix.value
//        code.font = FontConstants.bold?.withSize(16)
//        code.textColor = ColorConstants.textBlack
//        leftView.addSubview(code)
//        mobileField.leftView = leftView
//        mobileField.leftViewMode = .always
//        mobileField.textAlignment = .left
//        mobileField.setTitleVisible(true)
        
        cnicField.placeholder = "cnic".localized()
        cnicField.font = FontConstants.bold?.withSize(16)
        cnicField.textColor = ColorConstants.textBlack
        cnicField.selectedTitleColor = ColorConstants.orange
        cnicField.selectedLineColor = ColorConstants.orange
        cnicField.titleFormatter = titleFormatter
        
        continueButton.backgroundColor = ColorConstants.orange
        continueButton.setTitle("sign_up".localized(), for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.setTitleColor(ColorConstants.white, for: .normal)
        continueButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "sign_up".localized()
        
        scrollView.backgroundColor = ColorConstants.white
        setupTextView()
    }
    
    private func setupTextView() {
        textView.backgroundColor = .clear
        let forgotPasswordString = NSMutableAttributedString(string: "already_have_account".localized())
        forgotPasswordString.addAttribute(NSAttributedString.Key.font, value: FontConstants.regular?.withSize(16), range: NSMakeRange(0, forgotPasswordString.length))
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray, range: NSMakeRange(0, forgotPasswordString.length))
        
        let range = ("already_have_account".localized() as NSString).range(of: "sign_in".localized(), options: .caseInsensitive)
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray.cgColor, range: range)
        forgotPasswordString.addAttribute(NSAttributedString.Key.link, value: "sign_in", range: range)
        textView.linkTextAttributes = [ .foregroundColor: ColorConstants.orange ]
        textView.textColor = ColorConstants.textGray
        
        textView.attributedText = forgotPasswordString
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Router.pop(from: self)
        return true
    }
    
    @IBAction func backPressed(_ sender: Any) {
//        LocalStorage.clearToken()
        Router.pop(from: self)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        var isFormValid = true
        if firstnameField.text == "" {
            firstnameField.errorColor = ColorConstants.red
            firstnameField.errorMessage = "enterFirstName".localized()
            isFormValid = false
        }
        if !(cnicField.text?.isValidCnic() ?? false) {
            cnicField.errorColor = ColorConstants.red
            cnicField.errorMessage = "enterCnic".localized()
            isFormValid = false
        }
        if mobileField.text == "" {
            mobileField.errorColor = ColorConstants.red
            mobileField.errorMessage = "enterPhone".localized()
            isFormValid = false
        }
        
        if let mobileText = mobileField.text {
            if !mobileText.isEmpty {
                if (mobileText[mobileText.startIndex] != "0") || (mobileText[mobileText.index(after: mobileText.startIndex)] != "3") {
                    mobileField.errorColor = ColorConstants.red
                    mobileField.errorMessage = "enterPhone".localized()
                    isFormValid = false
                }
            }
        }
        
        if isFormValid {
            signupWith(cnic: cnicField.text!, fullname: firstnameField.text!, mobile: mobileField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cnicField {
            if (cnicField?.text?.count == 5) || (cnicField?.text?.count == 13) {
                if !(string == "") {
                    cnicField?.text = (cnicField?.text)! + "-"
                }
            }
            return !(textField.text!.count > 14 && (string.count ) > range.length)
        } else if textField == mobileField {
            if (mobileField.text?.count ?? 0) > 10 {
                if string == "" {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    @IBAction func removeError(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = nil
    }
}

extension RegisterViewController {
    
    func signupWith(cnic: String, fullname: String, mobile: String) {
        continueButton.showLoading()
        network.request("signupUser_new",
                        method: .post,
                        parameters: ["fullName": fullname,
                                     "mobileNumber": mobile,
                                     "cnicNumber":cnic],
                        encoding: URLEncoding.default,
                        headers: [HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: RegisterResponseModel.self,
                        success: { (response) in
            if let registerResponse = response as? RegisterResponseModel {
                if registerResponse.Code == "00", let token = registerResponse.Data?.access_token {
                    LocalStorage.saveTimeForToken()
                    LocalStorage.saveSignupAccessTokenObject(accessToken: token)
                    self.generateOtp(cnic: cnic)
                }
            }
        },
                        failure: { (error) in
            
            self.continueButton.hideLoading()
            if error?.code == 403 {
                self.generateOtp(cnic: cnic)
            } else if error?.code == 409 {
                
                Helper.showAlertWithTwoButton("Alert".localized(), message: (error?.localizedDescription.localized())!, buttonTitleOne: "cancel".localized(), buttonTitleTwo: "sign_in".localized(), controller: self, handlerOne: { _ in
                    
                    self.dismiss(animated: true, completion: nil)
                }, handlerTwo: { _ in
                    Router.pop(from: self)
                    
                })
                
            } else {
                if error?.code ?? 400 > 499 {
                    Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }else{
                    Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }
                
            }
        })
    }
    
    func generateOtp(cnic: String) {
        continueButton.showLoading()
        network.request("generateOTP_6",
                        method: .post,
                        parameters: ["sms_text": smsMessage.text,
                                     "CnicNumber": cnic,
                                     "is_login":0],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getSignupAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: GenerateOTPResponseModel.self,
                        success: { (response) in
            if let registerResponse = response as? GenerateOTPResponseModel {
                if registerResponse.Code == "00" {
//                    LocalStorage.saveTimeForToken()
                    LocalStorage.clearBiometric()
//                    if let response = response as? GenerateOTPResponseModel {
//                        LocalStorage.saveTimeForToken()
//                        LocalStorage.saveAccessTokenObject(accessToken: LocalStorage.getSignupAccessToken())
//                        Router.showVerification(from: self, accessToken: response.Data ?? "", cnic: cnic, mobile: self.mobileField.text!, isLogin: 0)
//                        Router.showVerification(from: self, accessToken: LocalStorage.getSignupAccessToken(), cnic: cnic, mobile: self.mobileField.text!, isLogin: 0)
//                    }
                    
                    Router.showVerification(
                        from: self,
                        accessToken: LocalStorage.getSignupAccessToken(),
                        cnic: cnic,
                        mobile: self.mobileField.text!,
                        isLogin: 0
                    )
                }
            }
            self.continueButton.hideLoading()
        },
                        failure: { (error) in
            self.continueButton.hideLoading()
            print(error)
            if error?.code ?? 400 > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
            
        })
    }
}
