//
//  HistoryFilterViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 19/06/2021.
//

import UIKit

class HistoryFilterViewController: UIViewController, Storyboarded, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mtagField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applybutton: UIButton!
    
    var mtags: [MtagDetailsObject]! = nil
    var callbackAction: ((String,String,String) -> ())?
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    let apiFormatter = DateFormatter()
    let mtagPickerView = UIPickerView()

    static var startDateSelected = ""
    static var endDateSelected = ""
    static var startDateSelectedRaw: Date? = nil
    static var endDateSelectedRaw: Date? = nil
    static var selectedMtag = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        mtagPickerView.delegate = self
        mtagPickerView.dataSource = self
        mtagField.inputView = mtagPickerView
        
        mtagField.font = FontConstants.bold?.withSize(15)
        mtagField.textColor = ColorConstants.textGray
        mtagField.text = "selectDate".localized()
        mtagField.isHidden = false
        mtagField.isUserInteractionEnabled = false// TODO: replace this field with simple label
        
        
        startDateField.font = FontConstants.bold?.withSize(15)
        startDateField.textColor = ColorConstants.textGray
        
        endDateField.font = FontConstants.bold?.withSize(15)
        endDateField.textColor = ColorConstants.textGray
        
        cancelButton.titleLabel?.font = FontConstants.bold?.withSize(15)
        cancelButton.tintColor = ColorConstants.textGray
        cancelButton.setTitle("cancel".localized(), for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = ColorConstants.textGray.cgColor
        
        applybutton.titleLabel?.font = FontConstants.bold?.withSize(15)
        applybutton.tintColor = ColorConstants.textGray
        applybutton.setTitle("apply".localized(), for: .normal)
        applybutton.backgroundColor = ColorConstants.orange
        applybutton.layer.cornerRadius = 10
        applybutton.setTitleColor(ColorConstants.white, for: .normal)
        
        formatter.dateFormat = "dd-MM-yyyy"
        apiFormatter.dateFormat = "yyyy-MM-dd"
        
        if HistoryFilterViewController.startDateSelectedRaw != nil {
            startDateField.text = "from".localized() + formatter.string(from: HistoryFilterViewController.startDateSelectedRaw!)
            HistoryFilterViewController.startDateSelected = apiFormatter.string(from: HistoryFilterViewController.startDateSelectedRaw!)
        } else {
            HistoryFilterViewController.startDateSelected = apiFormatter.string(from: Date() - TimeInterval(Constants.secondsInADay * 7))
            startDateField.text = "from".localized() + formatter.string(from: Date() - TimeInterval(Constants.secondsInADay * 7))
        }
        
        if HistoryFilterViewController.endDateSelectedRaw != nil {
            endDateField.text = "to".localized() + formatter.string(from: HistoryFilterViewController.endDateSelectedRaw!)
            HistoryFilterViewController.endDateSelected = apiFormatter.string(from: HistoryFilterViewController.endDateSelectedRaw!)
        } else {
            HistoryFilterViewController.endDateSelected = apiFormatter.string(from: Date())
            endDateField.text = "to".localized() + formatter.string(from: Date())
        }
        
        if HistoryFilterViewController.selectedMtag != "" {
//            mtagField.text = "mtag".localized() + ": " + HistoryFilterViewController.selectedMtag
        }
        
        createStartDatePicker()
    }
    
    func createStartDatePicker() {
        let starttoolbar = UIToolbar()
        starttoolbar.sizeToFit()
        let startdoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDonePressed))
        starttoolbar.setItems([startdoneButton], animated: true)
        startDateField.inputAccessoryView = starttoolbar
        startDateField.inputView = datePicker
        
        let endtoolbar = UIToolbar()
        endtoolbar.sizeToFit()
        let enddoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDonePressed))
        endtoolbar.setItems([enddoneButton], animated: true)
        endDateField.inputAccessoryView = endtoolbar
        endDateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        formatter.dateFormat = "dd-MM-yyyy"
        apiFormatter.dateFormat = "yyyy-MM-dd"
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func startDonePressed() {
        startDateField.text = "from".localized() + formatter.string(from: datePicker.date)
        HistoryFilterViewController.startDateSelectedRaw = datePicker.date
        HistoryFilterViewController.startDateSelected = apiFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func endDonePressed() {
        endDateField.text = "to".localized() + formatter.string(from: datePicker.date)
        HistoryFilterViewController.endDateSelectedRaw = datePicker.date
        HistoryFilterViewController.endDateSelected = apiFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func applyPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: {
            self.callbackAction?(HistoryFilterViewController.startDateSelected,HistoryFilterViewController.endDateSelected,HistoryFilterViewController.selectedMtag)
        })
    }
}

extension HistoryFilterViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mtags.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mtags[row].tokenno ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        HistoryFilterViewController.selectedMtag = mtags[row].tokenno ?? ""
//        mtagField.text = "mtag".localized() + ": " + (mtags[row].tokenno ?? "")
    }
}
