//
//  ViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 05/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import LocalAuthentication
//import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, Storyboarded {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var biometricLabel: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var cnicField: SkyFloatingLabelTextField!
    @IBOutlet weak var biometricButton: LoadingButton!
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var mobileField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: LoadingButton!
    @IBOutlet weak var textView: UITextView!
    
    let network = NetworkManager()
    var context = LAContext()
    static var biometricValue = false
    var titleFormatter = { (text: String) -> String in
        return text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cnicField.delegate = self
        mobileField.delegate = self
        context.localizedCancelTitle = "Enter CNIC/Mobile number"
        if Helper.biometricType() == .touch {
            biometricButton.setImage(UIImage(named: "finger-print"), for: .normal)
        }
        setupUI()

    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if LocalStorage.getAccessToken() != "" {
            Router.showHomeScreenAsRootVC()
        }
        
    }
    
    
  
    
    
    
    private func setupUI() {
        signinLabel.text = "sign_in".localized()
        signinLabel.font = FontConstants.bold?.withSize(25)
        signinLabel.textColor = ColorConstants.textGray
        welcomeLabel.text = "welcome".localized()
        welcomeLabel.font = FontConstants.regular?.withSize(16)
        welcomeLabel.textColor = ColorConstants.textBlack
        
        mobileField.font = FontConstants.bold?.withSize(16)
        mobileField.textColor = ColorConstants.textBlack
        mobileField.selectedTitleColor = ColorConstants.orange
        mobileField.selectedLineColor = ColorConstants.orange
        mobileField.titleFormatter = titleFormatter
        mobileField.title = "mobile".localized()
        mobileField.placeholder = "mobile".localized()
        
        //        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: mobileField.frame.size.height))
        //        let code = UILabel(frame: CGRect(x: 0, y: 17, width: 20, height: 20))
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
        continueButton.setTitle("sign_in".localized(), for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.setTitleColor(ColorConstants.white, for: .normal)
        continueButton.titleLabel?.font = FontConstants.bold?.withSize(16)
        
        biometricLabel.text = "biometricLogin".localized()
        biometricLabel.font = FontConstants.regular?.withSize(15)
        biometricLabel.textColor = ColorConstants.textGray
        
        biometricSwitch.onTintColor = ColorConstants.orange
        
        if LocalStorage.getBiometricMobile() != "" && LocalStorage.getBiometricCnic() != "" {
            biometricSwitch.setOn(true, animated: false)
            LoginViewController.biometricValue = true
        } else {
            biometricSwitch.setOn(false, animated: false)
            LoginViewController.biometricValue = false
        }
        
        formView.backgroundColor = ColorConstants.white
        view.backgroundColor = ColorConstants.screenBackground
        
        setupTextView()
    }
    
    private func setupTextView() {
        textView.backgroundColor = .clear
        let forgotPasswordString = NSMutableAttributedString(string: "not_applied_yet".localized())
        forgotPasswordString.addAttribute(NSAttributedString.Key.font, value: FontConstants.regular?.withSize(16), range: NSMakeRange(0, forgotPasswordString.length))
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray, range: NSMakeRange(0, forgotPasswordString.length))
        
        let range = ("not_applied_yet".localized() as NSString).range(of: "sign_up".localized(), options: .caseInsensitive)
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray.cgColor, range: range)
        forgotPasswordString.addAttribute(NSAttributedString.Key.link, value: "sign_up", range: range)
        textView.linkTextAttributes = [ .foregroundColor: ColorConstants.orange ]
        textView.textColor = ColorConstants.textGray
        
        textView.attributedText = forgotPasswordString
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        Router.showRegistration(from: self)
        return true
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        var isFormValid = true
        let currentString: NSString = (mobileField.text) as NSString? ?? ""
        
        if !(cnicField.text?.isValidCnic() ?? false) {
            cnicField.errorColor = ColorConstants.red
            cnicField.errorMessage = "enterCnic".localized()
            isFormValid = false
        }
        
        if (mobileField.text == "" || currentString.length != 11) {
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
            loginWith(cnic: cnicField.text!, mobile: mobileField.text!)
        }
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        if biometricSwitch.isOn {
            LoginViewController.biometricValue = true
        } else {
            if LocalStorage.getBiometricMobile() != "" && LocalStorage.getBiometricCnic() != "" {
                Helper.showAlertWithTwoButton("disablebiometric".localized(), message: "diablebiometricMsg".localized(), buttonTitleOne: "no".localized(), buttonTitleTwo: "yes".localized(), controller: self, handlerOne: { _ in
                    self.biometricSwitch.setOn(true, animated: true)
                }, handlerTwo: { _ in
                    self.biometricSwitch.setOn(false, animated: true)
                    LoginViewController.biometricValue = false
                    LocalStorage.clearBiometric()
                })
            }
        }
    }
    
    @IBAction func biometricPressed(_ sender: UIButton) {
        if LocalStorage.getBiometricMobile() != "" && LocalStorage.getBiometricCnic() != "" {
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Sign in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.loginWith(cnic: LocalStorage.getBiometricCnic(), mobile: LocalStorage.getBiometricMobile())
                        }
                    } else {
                        DispatchQueue.main.async { [unowned self] in
                            self.cnicField.errorMessage = "enterCnic".localized()
                            self.mobileField.errorMessage = "enterPhone".localized()
                        }
                        print(error?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            }
        } else {
            Helper.showAlert("enablebiometric".localized(), message: "signinFirstBiometric".localized(), controller: self)
        }
    }
    
    @IBAction func removeError(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = nil
    }
    
}

extension LoginViewController {
    
    func loginWith(cnic: String, mobile: String) {
        continueButton.showLoading()
        continueButton.isEnabled = false
        network.request("loginUser_new",
                        method: .post,
                        parameters: ["CnicNumber":cnic,
                                     "MobileNum":mobile,
                                     "meta_data": Helper.getDeviceInformation()],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: AcessTokenResponseModel.self,
                        success: { (response) in
            if let loginResponse = response as? AcessTokenResponseModel {
                if let token = loginResponse.access_token {
                    if LoginViewController.biometricValue == true {
                        LocalStorage.saveCNICforBiometric(cnic: cnic)
                        LocalStorage.saveMobileforBiometric(mobile: mobile)
                    }
                    
                    LocalStorage.saveTimeForToken()
                    
                    if let code = loginResponse.Code {
                        if code.elementsEqual("10"){
                            loginConstant.openFromLogin = true
                            LocalStorage.saveAccessTokenObject(accessToken: token)
                            Router.showHomeScreenAsRootVC()
                        }else{
                            self.generateOtp(cnic: cnic, token: token, mobile: mobile)
                        }
                    }else{
                        self.generateOtp(cnic: cnic, token: token, mobile: mobile)
                    }
                    
                   
                    

                }
            }
        },
                        failure: { (error) in
            self.continueButton.hideLoading()
            self.continueButton.isEnabled = true
            print(error?.localizedDescription)
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else if (error?.code ?? 400) == 401 {
                Helper.showAlertWithTwoButton("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), buttonTitleOne: "cancel".localized(), buttonTitleTwo: "sign_up".localized(), controller: self, handlerOne: nil, handlerTwo: {_ in
                    Router.showRegistration(from: self)
                })
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                
                
            }
            

        })
    }
    
    func generateOtp(cnic: String, token: String, mobile: String) {
        continueButton.showLoading()
        
        network.request("generateOTP_6",
                        method: .post,
                        parameters: ["sms_text": smsMessage.text,
                                     "CnicNumber": cnic,
                                     "is_login":1],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(token)",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: GenerateOTPResponseModel.self,
                        success: { (response) in
            if let registerResponse = response as? GenerateOTPResponseModel {
                if registerResponse.Code == "00" {
//                    LocalStorage.saveTimeForToken()
                    Router.showVerification(from: self, accessToken: token, cnic: cnic, mobile: mobile, isLogin: 1)
                }
            }
            self.continueButton.hideLoading()
            self.continueButton.isEnabled = true
        },
                        failure: { (error) in
            self.continueButton.hideLoading()
            self.continueButton.isEnabled = true
            if error?.code == 102 {
                Helper.showAlertWithTwoButton("error".localized(), message: "couldNotSendOtp".localized(), buttonTitleOne: " Cancel".localized(), buttonTitleTwo: " Retry".localized(), controller: self, handlerOne: nil, handlerTwo: {_ in
                    self.generateOtp(cnic: cnic, token: token, mobile: mobile)
                })
            } else {
                
                if (error?.code ?? 400) > 499 {
                    Helper.showAlert("error".localized(), message: "\(error)", controller: self)
                }else{
                    Helper.showAlert("Alert".localized(), message: "\(error)", controller: self)
                }

            }
        })
    }
}

