//
//  TollCalculatorViewController.swift
//  Smart Motorways
//
//  Created by shayan on 07/12/2021.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class TollCalculatorViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var searchByTitle: UILabel!
    @IBOutlet weak var tollRateTitle: UILabel!
    @IBOutlet weak var tollRateCount: UILabel!
    
    @IBOutlet weak var motorwayPicker: UIPickerView!
    @IBOutlet weak var fromInterchangePicker: UIPickerView!
    @IBOutlet weak var toInterchangePicker: UIPickerView!
    @IBOutlet weak var transportPicker: UIPickerView!
    
    @IBOutlet weak var calculateTollButton: UIButton!
    
    @IBOutlet weak var transportTitle: UILabel!
    
    private let motorways = [
        CalculateTollTypeModel(name: "M1", id: 1),
        CalculateTollTypeModel(name: "M2", id: 2),
        CalculateTollTypeModel(name: "M3", id: 3),
        CalculateTollTypeModel(name: "M9", id: 9),
        CalculateTollTypeModel(name: "Lahore Sialkot Motorway (LSM)", id: 11),
        CalculateTollTypeModel(name: "Swat Motorway", id: 40),
        CalculateTollTypeModel(name: "Lahore Ring Road (LRR)", id: 50)
    ]
    
    private let vehicles = [
        CalculateTollTypeModel(name: "Car", id: 1),
        CalculateTollTypeModel(name: "Wagon", id: 2),
        CalculateTollTypeModel(name: "Coaster", id: 3),
        CalculateTollTypeModel(name: "Bus", id: 4),
        CalculateTollTypeModel(name: "Truck 2/3 Axle", id: 5),
        CalculateTollTypeModel(name: "Trailer", id: 6)
    ]
    
    private var mtags = [MtagDetailsObject]()
    
    private var motorwayStations = [MotorwayStationsDataModel]()
    
    private var tollResult = 0
    
    private let network = NetworkManager()
    
    private var searchByToggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        initialSetup()
        
        motorwayPicker.delegate = self
        fromInterchangePicker.delegate = self
        toInterchangePicker.delegate = self
        transportPicker.delegate = self
        
        mtags = HomeScreenViewController.mtagDetailList
        
//        getActiveMtags {
        self.getMotorwayStations(for: self.motorways[self.motorwayPicker.selectedRow(inComponent: 0)])
//        }
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "tollCalculator".localized()
        
        if !mtags.isEmpty {
            transportTitle.text = "MTAG ID"
            searchByTitle.isHidden = false
        } else {
            searchByToggle = true
            transportTitle.text = "Vehicle Type"
            searchByTitle.isHidden = true
        }
        
        searchByTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchByTitlePressed)))
    }
    
    func setupActivityIndicator() {
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
    }
    
    private func initialSetup() {
        
        searchByTitle.font = FontConstants.bold?.withSize(16)
        searchByTitle.textColor = ColorConstants.textGray
        searchByTitle.text = "searchByVehicle".localized()
        
        tollRateTitle.font = FontConstants.bold?.withSize(20)
        tollRateTitle.textColor = ColorConstants.white
        tollRateTitle.text = "tollRate".localized()
        
        tollRateCount.font = FontConstants.bold?.withSize(20)
        tollRateCount.textColor = ColorConstants.white
        tollRateCount.text = "\(tollResult) PKR"
        
        calculateTollButton.backgroundColor = ColorConstants.orange
        calculateTollButton.setTitle("calculate_toll_rate".localized(), for: .normal)
        calculateTollButton.layer.cornerRadius = 10
        calculateTollButton.setTitleColor(UIColor.white, for: .normal)
        calculateTollButton.titleLabel?.font = FontConstants.bold?.withSize(16)
        
//        if !mtags.isEmpty {
//            transportTitle.text = "MTAG ID"
//            searchByTitle.isHidden = false
//        } else {
//            transportTitle.text = "Vehicle Type"
//            searchByTitle.isHidden = true
//        }
    }
    
    private func getMotorwayStations(for motorway: CalculateTollTypeModel) {
        
        activityIndicator.startAnimating()
        containerView.isHidden = true
        network.request(
            "getMotStations",
            method: .post,
            parameters: ["mwid": motorway.getID()],
            headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                      HeaderConstants.accept: HeaderConstants.acceptValue],
            modelType: MotorwayStationsModel.self,
            success: { response in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                if let response = response as? MotorwayStationsModel {
                    if let stationData = response.data {
                        self.motorwayStations = stationData
                        self.fromInterchangePicker.reloadComponent(0)
                        self.toInterchangePicker.reloadComponent(0)
                    }
                    
                    self.initialSetup()
                }
            },
            failure: { error in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                self.initialSetup()
                if error?.code ?? 400 > 499 {
                    Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }else{
                    Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }
                
            }
        )
    }
    
    private func calculateToll(
        for entry: MotorwayStationsDataModel,
        exit: MotorwayStationsDataModel,
        type: Int
    ) {
        
        print("ACCESS TOKEN: \(LocalStorage.getAccessToken())")
        
        activityIndicator.startAnimating()
        containerView.isHidden = true
        network.request(
            "calculateToll",
            method: .post,
            parameters: [
                "entry": Int(entry.getStationID()) ?? 0,
                "exit": Int(exit.getStationID()) ?? 0,
                "type": type
            ],
            headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                      HeaderConstants.accept: HeaderConstants.acceptValue],
            modelType: CalculateTollModel.self,
            success: { response in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                if let response = response as? CalculateTollModel {
                    self.tollRateCount.text = "\(response.data?.first?.toll ?? "0") PKR"
                }
            },
            failure: { error in
                self.activityIndicator.stopAnimating()
                self.containerView.isHidden = false
                if error?.code ?? 400 > 499 {
                    Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }else{
                    Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
                }
                
                
            }
        )
    }
    
//    func getActiveMtags(completion: @escaping () -> Void) {
//        activityIndicator.startAnimating()
//        containerView.isHidden = true
//        network.request("getActiveMtags",
//                        method: .post,
//                        encoding: JSONEncoding.default,
//                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
//                                  HeaderConstants.accept:HeaderConstants.acceptValue],
//                        modelType: ActiveMtagResponseModel.self,
//                        success: { (response) in
//                            self.activityIndicator.stopAnimating()
//                            self.containerView.isHidden = false
//                            if let response = response as? ActiveMtagResponseModel {
//                                self.mtags = response.Data ?? []
//                                completion()
//                            }
//                        },
//                        failure: { (error) in
//                            self.activityIndicator.stopAnimating()
//                            self.containerView.isHidden = false
//                            self.searchByToggle = true
//                            self.mtags = []
//                            completion()
//                        })
//    }
    
    @objc
    func searchByTitlePressed() {
        if searchByToggle {
            searchByTitle.text = "SEARCH BY VEHICLE"
            transportTitle.text = "MTAG ID"
        } else {
            searchByTitle.text = "SEARCH BY MTAG"
            transportTitle.text = "Vehicle Type"
        }
        
        searchByToggle.toggle()
        transportPicker.reloadComponent(0)
    }
    
    @IBAction func backPressed(sender: UIButton) {
        Router.pop(from: self)
    }
    
    @IBAction func calculateTollPressed(sender: UIButton) {
        
        
        
        let entryStationID = motorwayStations[fromInterchangePicker.selectedRow(inComponent: 0)]
        let exitStationID = motorwayStations[toInterchangePicker.selectedRow(inComponent: 0)]
        var type: Int
        
        if entryStationID.getStationID() != exitStationID.getStationID() {
            if !searchByToggle {
                let vehicleID = Helper.vehicleID(from: mtags[transportPicker.selectedRow(inComponent: 0)].veh_type ?? "")
                type = vehicleID
            } else {
                type = vehicles[transportPicker.selectedRow(inComponent: 0)].getID()
            }
            calculateToll(for: entryStationID, exit: exitStationID, type: type)
            print("DEBUG: \(entryStationID), \(exitStationID), \(type)")
        } else {
            Helper.showAlert("Alert".localized(), message: "Please select a different entry and exit station.", controller: self)
        }
    }
}

extension TollCalculatorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == motorwayPicker {
            return motorways.count
        } else if pickerView == fromInterchangePicker {
            return motorwayStations.count
        } else if pickerView == toInterchangePicker {
            return motorwayStations.count
        } else if pickerView == transportPicker {
            if !mtags.isEmpty {
                if !searchByToggle {
                    return mtags.count
                } else {
                    return vehicles.count
                }
            } else {
                return vehicles.count
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == motorwayPicker {
            return motorways[row].getName()
        } else if pickerView == fromInterchangePicker {
            return motorwayStations[row].getStationName()
        } else if pickerView == toInterchangePicker {
            return motorwayStations[row].getStationName()
        } else if pickerView == transportPicker {
            if !mtags.isEmpty {
                if !searchByToggle {
                    return mtags[row].tokenno
                } else {
                    return vehicles[row].getName()
                }
            } else {
                return vehicles[row].getName()
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == motorwayPicker {
            if row < motorways.count{
                print(motorways[row].getName())
                getMotorwayStations(for: motorways[row])
            }
            
        } else if pickerView == transportPicker {
//            print(vehicles[row].getName())
        }
    }
}
