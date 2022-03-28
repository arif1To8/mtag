//
//  AddFeedbackViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 13/09/2021.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class AddFeedbackViewController: UIViewController, Storyboarded, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var fullnameField: SkyFloatingLabelTextField!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var cnicField: SkyFloatingLabelTextField!
    @IBOutlet weak var tokenNumberField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNumberField: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vehicleCategoryField: SkyFloatingLabelTextField!
    @IBOutlet weak var nextButton: LoadingButton!
    @IBOutlet weak var complaintCategoryField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleNumberField: SkyFloatingLabelTextField!
    @IBOutlet weak var remarksLabel: UILabel!
    @IBOutlet weak var remarksTextView: UITextView!
    
    var mtags = HomeScreenViewController.mtagDetailList
    let mtagPickerView = UIPickerView()
    let complaintPickerView = UIPickerView()
    let complaintCategories = ["Double Toll Deduction", "Wrong Toll Deduction", "Additional Manual Transaction", "Mtag Not Read", "Mtag Updated Balance not Shown", "Change ownership"]
    let network = NetworkManager()
    var selectedToken = ""
    var dateOfIssue = ""
    var titleFormatter = { (text: String) -> String in
        return text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenNumberField.isHidden = true
        vehicleCategoryField.isHidden = true
        complaintCategoryField.isHidden = true
        vehicleNumberField.isHidden = true
        
        mtagPickerView.delegate = self
        mtagPickerView.dataSource = self
        tokenNumberField.inputView = mtagPickerView
        complaintPickerView.delegate = self
        complaintPickerView.dataSource = self
        complaintCategoryField.inputView = complaintPickerView
        remarksTextView.delegate = self
        mobileNumberField.delegate = self
        setupUI()
    }
    
    func setupUI() {
        mtags = HomeScreenViewController.mtagDetailList
        
        fullnameField.placeholder = "fullname".localized()
        fullnameField.font = FontConstants.bold?.withSize(16)
        fullnameField.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        fullnameField.selectedTitleColor = ColorConstants.orange
        fullnameField.selectedLineColor = ColorConstants.orange
        fullnameField.titleFormatter = titleFormatter
        fullnameField.text = LocalStorage.getUserInfo()?.fullname
        fullnameField.isUserInteractionEnabled = false
        
        vehicleCategoryField.placeholder = "vehicleType".localized()
        vehicleCategoryField.font = FontConstants.bold?.withSize(16)
        vehicleCategoryField.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        vehicleCategoryField.selectedTitleColor = ColorConstants.orange
        vehicleCategoryField.selectedLineColor = ColorConstants.orange
        vehicleCategoryField.titleFormatter = titleFormatter
        vehicleCategoryField.isUserInteractionEnabled = false
        
        vehicleNumberField.placeholder = "registrationNum".localized()
        vehicleNumberField.font = FontConstants.bold?.withSize(16)
        vehicleNumberField.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        vehicleNumberField.selectedTitleColor = ColorConstants.orange
        vehicleNumberField.selectedLineColor = ColorConstants.orange
        vehicleNumberField.titleFormatter = titleFormatter
        vehicleNumberField.isUserInteractionEnabled = false
        
        remarksTextView.font = FontConstants.bold?.withSize(16)
        remarksTextView.layer.cornerRadius = 12
        remarksTextView.backgroundColor = ColorConstants.silver.withAlphaComponent(0.3)
        remarksTextView.isUserInteractionEnabled = true
        remarksTextView.text = "addYourRemarkHere".localized()
        remarksTextView.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        
        complaintCategoryField.placeholder = "complaintType".localized()
        complaintCategoryField.font = FontConstants.bold?.withSize(16)
        complaintCategoryField.textColor = ColorConstants.textBlack
        complaintCategoryField.selectedTitleColor = ColorConstants.orange
        complaintCategoryField.selectedLineColor = ColorConstants.orange
        complaintCategoryField.titleFormatter = titleFormatter
        complaintCategoryField.isUserInteractionEnabled = true
        
        tokenNumberField.placeholder = mtags.count == 0 ? "noMtagAvailable".localized() : "selectMtag".localized()
        tokenNumberField.font = FontConstants.bold?.withSize(16)
        tokenNumberField.textColor = ColorConstants.textBlack
        tokenNumberField.selectedTitleColor = ColorConstants.orange
        tokenNumberField.selectedLineColor = ColorConstants.orange
        tokenNumberField.titleFormatter = titleFormatter
        tokenNumberField.isUserInteractionEnabled = mtags.count != 0
        
        cnicField.placeholder = "cnic".localized()
        cnicField.font = FontConstants.bold?.withSize(16)
        cnicField.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        cnicField.selectedTitleColor = ColorConstants.orange
        cnicField.selectedLineColor = ColorConstants.orange
        cnicField.titleFormatter = titleFormatter
        cnicField.text = LocalStorage.getUserInfo()?.cnic
        cnicField.isUserInteractionEnabled = false
        
        mobileNumberField.placeholder = "mobile".localized()
        mobileNumberField.font = FontConstants.bold?.withSize(16)
        mobileNumberField.textColor = ColorConstants.textBlack
        mobileNumberField.selectedTitleColor = ColorConstants.orange
        mobileNumberField.selectedLineColor = ColorConstants.orange
        mobileNumberField.titleFormatter = titleFormatter
        mobileNumberField.text = LocalStorage.getUserInfo()?.mobileNumber
        mobileNumberField.isUserInteractionEnabled = false
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "submit_feedback".localized()
        
        remarksLabel.font = FontConstants.bold?.withSize(16)
        remarksLabel.textColor = ColorConstants.textGray
        remarksLabel.text = "remarks".localized()
        
        scrollView.backgroundColor = ColorConstants.white
        
        nextButton.backgroundColor = ColorConstants.orange
        nextButton.setTitle("submit".localized(), for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.setTitleColor(ColorConstants.white, for: .normal)
        nextButton.titleLabel?.font = FontConstants.regular?.withSize(16)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
    
    @IBAction func nextPressed(_ sender: LoadingButton) {
        var shouldAllow = true
        if fullnameField.text == "" {
            shouldAllow = false
        }
        if cnicField.text == "" {
            shouldAllow = false
        }
        if mobileNumberField.text == "" {
            shouldAllow = false
        }
        //        if tokenNumberField.text == "" {
        //            shouldAllow = false
        //        }
        //        if vehicleCategoryField.text == "" {
        //            shouldAllow = false
        //        }
        //        if complaintCategoryField.text == "" {
        //            shouldAllow = false
        //        }
        //        if vehicleNumberField.text == "" {
        //            shouldAllow = false
        //        }
        if remarksTextView.text == "" || remarksTextView.text == "addYourRemarkHere".localized() {
            shouldAllow = false
        }
        if shouldAllow {
            insertFeedback()
        } else {
            if mtags.count == 0 {
                Helper.showAlert("Alert".localized(), message: "needMtagAssigned".localized(), controller: self)
            } else {
                Helper.showAlert("Alert".localized(), message: "completeForm".localized(), controller: self)
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "addYourRemarkHere".localized() {
            remarksTextView.text = ""
            remarksTextView.textColor = ColorConstants.textBlack
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumberField {
            if (mobileNumberField.text?.count ?? 0) > 10 {
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
}


extension AddFeedbackViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == mtagPickerView {
            return mtags.count
        } else {
            return complaintCategories.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == mtagPickerView {
            return mtags[row].tokenno ?? ""
        } else {
            return complaintCategories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mtagPickerView {
            tokenNumberField.text = "mtag".localized() + ": " + (mtags[row].tokenno ?? "")
            vehicleCategoryField.text = mtags[row].veh_type
            vehicleNumberField.text = mtags[row].registration
            selectedToken = mtags[row].tokenno ?? ""
            dateOfIssue = mtags[row].issuedate ?? ""
        } else {
            complaintCategoryField.text = complaintCategories[row]
        }
    }
}

extension AddFeedbackViewController {
    func insertFeedback() {
        nextButton.showLoading()
        self.view.isUserInteractionEnabled = false
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH:mm:ss"
        let dateFormatterIssueDate = DateFormatter()
        dateFormatterIssueDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterIssueDate.dateFormat = "dd-MMM-yyyy"
        let issueDate = dateFormatterIssueDate.date(from: dateOfIssue) ?? Date()
        let parameters = ["fullName":fullnameField.text ?? "",
                          "mobileNumber": mobileNumberField.text ?? "",
                          "cnic":cnicField.text ?? "",
                          "itokenNo":selectedToken,
                          "vehicleCategory":Helper.vehicleCode(from: vehicleCategoryField.text ?? ""),
                          "complaintCategory":complaintCategoryField.text ?? "",
                          "vehicleNumber":vehicleNumberField.text ?? "",
                          "dateOfIssue":dateFormatter.string(from: issueDate),
                          "submissionDate":dateFormatter.string(from: date),
                          "remarks":remarksTextView.text ?? ""]
        network.request("insertFeedback",
                        method: .post,
                        parameters: parameters,
                        encoding: URLEncoding.default,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())"],
                        modelType: EmptyModel.self,
                        success: { (response) in
            self.nextButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            Helper.showAlertWithOneButton("success".localized(), message: "feedback_done".localized(), buttonTitle: "ok".localized(), controller: self, action: { _ in
                Router.pop(from: self)
            })
        },
                        failure: { (error) in
            self.nextButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            
            if error?.code ?? 400 > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
            
        })
    }
}
