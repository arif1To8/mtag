
//
//  VerificationViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 06/06/2021.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class VerificationViewController: UIViewController, Storyboarded, OTPDelegate, UITextViewDelegate {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var continueButton: LoadingButton!
    @IBOutlet weak var verificationTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let otpStackView = OTPStackView()
    var accessToken = ""
    var cnic: String = ""
    var mobile: String = ""
    var isLogin: Int!
    let network = NetworkManager()
    
//    var seconds = 59
    var seconds = 119
    var timer = Timer()
    var isTimerRunning = false
    
    private var verifyOTPCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        runTimer()
    }
    
    private func setupUI() {
//        timerLabel.text = "00:\(seconds)"
        timerLabel.text = timeFormatted(seconds)
        textView.isUserInteractionEnabled = false
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "verification".localized()
        
        continueButton.isEnabled = false
        continueButton.setTitle("verify".localized(), for: .normal)
        continueButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        continueButton.backgroundColor = ColorConstants.orange
        continueButton.setTitleColor(ColorConstants.white, for: .normal)
        
        verificationTitle.text = "verification".localized()
        verificationTitle.textColor = ColorConstants.textBlack
        verificationTitle.font = FontConstants.bold?.withSize(25)
//        "We have sent you code via SMS for mobile number verification"
        var mobileNum = self.mobile
        if  mobileNum.isEmpty{
            mobileNum = "mobile number"
        }
        instructionLabel.textColor = ColorConstants.textGray
        instructionLabel.font = FontConstants.regular?.withSize(16)
        instructionLabel.attributedText = Helper.attributedText(withString: "We have sent you code via SMS at \(mobileNum) for verification", boldString: mobileNum, font: (FontConstants.regular?.withSize(16))!)
        
        
        timerLabel.textColor = ColorConstants.textBlack
        timerLabel.font = FontConstants.bold?.withSize(16)
        
        setupTextView(enable: false)
        
        NSLayoutConstraint.activate([
            otpStackView.leadingAnchor.constraint(equalTo: otpView.leadingAnchor),
            otpStackView.trailingAnchor.constraint(equalTo: otpView.trailingAnchor),
            otpStackView.bottomAnchor.constraint(equalTo: otpView.bottomAnchor),
            otpStackView.topAnchor.constraint(equalTo: otpView.topAnchor)
        ])
    }
    
    func runTimer() {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    @objc func updateTimer() {
        seconds -= 1
//        if seconds < 10 {
//            timerLabel.text = "00:0\(seconds)"
//        } else {
//            timerLabel.text = "00:\(seconds)"
//        }
        
        
        timerLabel.text = timeFormatted(seconds)
        
        if seconds == 0 {
            timer.invalidate()
            textView.isUserInteractionEnabled = true
            setupTextView(enable: true)
        }
    }
    
    private func setupTextView(enable: Bool) {
        textView.backgroundColor = .clear
        let forgotPasswordString = NSMutableAttributedString(string: "didntReceiveCode".localized())
        forgotPasswordString.addAttribute(NSAttributedString.Key.font, value: FontConstants.regular?.withSize(16), range: NSMakeRange(0, forgotPasswordString.length))
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray, range: NSMakeRange(0, forgotPasswordString.length))
        
        let range = ("didntReceiveCode".localized() as NSString).range(of: "resend".localized(), options: .caseInsensitive)
        forgotPasswordString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorConstants.textGray.cgColor, range: range)
        forgotPasswordString.addAttribute(NSAttributedString.Key.link, value: "resend", range: range)
        textView.linkTextAttributes = [ .foregroundColor: enable ? ColorConstants.orange : ColorConstants.silver ]
        textView.textColor = ColorConstants.textGray
        
        textView.attributedText = forgotPasswordString
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
//        LocalStorage.clearToken()
        Router.pop(from: self)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        generateOtp(cnic: cnic, token: accessToken)
        textView.isUserInteractionEnabled = false
        setupTextView(enable: false)
//        seconds = 59
        seconds = 119
        runTimer()
//        timerLabel.text = "00:\(seconds)"
        timerLabel.text = timeFormatted(seconds)
        return true
    }
    
    @IBAction func continuebuttonPressed(_ sender: UIButton) {
        if otpStackView.getOTP().count == 6 {
            verifyOtpWith(otp: otpStackView.getOTP(), token: accessToken)
        }
    }
    
    func didChangeValidity(isValid: Bool) {
        print(isValid)
        if isValid {
            continueButton.isEnabled = true
            if otpStackView.getOTP().count == 6 {
                verifyOtpWith(otp: otpStackView.getOTP(), token: accessToken)
            }
        }
    }
}

extension VerificationViewController {
    
    func verifyOtpWith(otp: String, token: String) {
        print(otp)
        continueButton.showLoading()
        network.request("verifyOTP",
                        method: .post,
                        parameters: ["Code":otp,
                                     "is_login":isLogin,
                                     "meta_data": Helper.getDeviceInformation()],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(token)",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: LoginResponseModel.self,
                        success: { (response) in
                            if let loginResponse = response as? LoginResponseModel {
                                if loginResponse.Code == "00" {
                                    if LoginViewController.biometricValue == true {
                                        LocalStorage.saveCNICforBiometric(cnic: self.cnic)
                                        LocalStorage.saveMobileforBiometric(mobile: self.mobile)
                                    }
                                    LocalStorage.saveAccessTokenObject(accessToken: token)
//                                    NotificationCenter.default.post(name: Notification.Name("checkVersionHome"), object: nil)
                                    loginConstant.openFromLogin = true
                                    Router.showHomeScreenAsRootVC()
                                }
                            }
                            self.continueButton.hideLoading()
                        },
                        failure: { (error) in
                            self.continueButton.hideLoading()
                            
                            if self.verifyOTPCount < 2 {
                                self.verifyOTPCount += 1
                                self.otpStackView.textFieldsCollection.forEach { textField in
                                    textField.text = ""
                                }
                                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                            } else {
                                Helper.showAlertWithOneButton("Alert".localized(), message: "You've already tried 3 attempts, please enter your credentials again to proceed." , buttonTitle: "ok".localized(), controller: self) { _ in
                                    Router.pop(from: self)
                                }
                            }
                        })
    }
    
    func generateOtp(cnic: String, token: String) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        network.request("generateOTP_6",
                        method: .post,
                        parameters: ["sms_text": smsMessage.text,
                                     "CnicNumber": cnic,
                                     "is_login":isLogin ?? 0],
                        encoding: JSONEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(token)",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: GenerateOTPResponseModel.self,
                        success: { (response) in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if let response = response as? GenerateOTPResponseModel {
                self.accessToken = response.Data ?? ""
            }
        },
                        failure: { (error) in
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
        })
    }
}
