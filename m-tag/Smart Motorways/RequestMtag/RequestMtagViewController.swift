//
//  RequestMtagViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import MediaWatermark

enum ImageType {
    case carFront
    case carBack
    case cnicFront
    case cnicBack
    case carDoc
}

class RequestMtagViewController: UIViewController, Storyboarded, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var makeField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNumberField: SkyFloatingLabelTextField!
    @IBOutlet weak var vehicleTypeField: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scanCarLabel: UILabel!
    @IBOutlet weak var registrationNumField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: LoadingButton!
    @IBOutlet weak var ownerNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var cnicField: SkyFloatingLabelTextField!
    @IBOutlet weak var scanCnicLabel: UILabel!
    @IBOutlet weak var addressField: SkyFloatingLabelTextField!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var scanVehicleDocLabel: UILabel!
    
    @IBOutlet weak var carDocImageView: UIImageView!
    @IBOutlet weak var carFrontImageView: UIImageView!
    @IBOutlet weak var carBackImageView: UIImageView!
    @IBOutlet weak var cnicFrontImageView: UIImageView!
    @IBOutlet weak var cnicBackImageView: UIImageView!
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let carPickerView = UIPickerView()
    let vehicleTypes = ["Car", "Wagon", "Coaster", "Bus", "Truck 2/3 Axle", "Trailer"]
    let vehicleTypeApi = ["F1", "F2", "F3", "F4", "F5", "F6"]
    var vehicleTypeSelected = "F1"
    let imagePicker = UIImagePickerController()
    var currentImageTapped: ImageType = .carFront
    var chooseFromPhotos = false
    let network = NetworkManager()
    var titleFormatter = { (text: String) -> String in
        return text
    }
    
    var cnicFrontAdded = false
    var cnicBackAdded = false
    var carFrontAdded = false
    var carBackAdded = false
    var carDocAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        cnicField.delegate = self
        registrationNumField.delegate = self
        imagePicker.delegate = self
        carPickerView.delegate = self
        carPickerView.dataSource = self
        vehicleTypeField.inputView = carPickerView
        setupUI()
        addGestures()
    }
    
    private func addGestures() {
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(carFront(tapGestureRecognizer:)))
        carFrontImageView.isUserInteractionEnabled = true
        carFrontImageView.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(carBack(tapGestureRecognizer:)))
        carBackImageView.isUserInteractionEnabled = false
        carBackImageView.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(cnicFront(tapGestureRecognizer:)))
        cnicFrontImageView.isUserInteractionEnabled = true
        cnicFrontImageView.addGestureRecognizer(tapGestureRecognizer4)
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(cnicBack(tapGestureRecognizer:)))
        cnicBackImageView.isUserInteractionEnabled = true
        cnicBackImageView.addGestureRecognizer(tapGestureRecognizer5)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(carDoc(tapGestureRecognizer:)))
        carDocImageView.isUserInteractionEnabled = true
        carDocImageView.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    private func setupUI() {
        makeField.placeholder = "make".localized()
        makeField.font = FontConstants.bold?.withSize(16)
        makeField.textColor = ColorConstants.textBlack
        makeField.selectedTitleColor = ColorConstants.orange
        makeField.selectedLineColor = ColorConstants.orange
        makeField.titleFormatter = titleFormatter
        
        mobileNumberField.placeholder = "mobile".localized()
        mobileNumberField.font = FontConstants.bold?.withSize(16)
        mobileNumberField.textColor = ColorConstants.textBlack
        mobileNumberField.selectedTitleColor = ColorConstants.orange
        mobileNumberField.selectedLineColor = ColorConstants.orange
        mobileNumberField.titleFormatter = titleFormatter
        mobileNumberField.text = LocalStorage.getUserInfo()?.mobileNumber
        
        vehicleTypeField.placeholder = "vehicleType".localized()
        vehicleTypeField.font = FontConstants.bold?.withSize(16)
        vehicleTypeField.textColor = ColorConstants.textBlack
        vehicleTypeField.selectedTitleColor = ColorConstants.orange
        vehicleTypeField.selectedLineColor = ColorConstants.orange
        vehicleTypeField.titleFormatter = titleFormatter
        vehicleTypeField.text = vehicleTypes[0]
        
        registrationNumField.placeholder = "registrationNum".localized()
        registrationNumField.font = FontConstants.bold?.withSize(16)
        registrationNumField.textColor = ColorConstants.textBlack
        registrationNumField.selectedTitleColor = ColorConstants.orange
        registrationNumField.selectedLineColor = ColorConstants.orange
        registrationNumField.titleFormatter = titleFormatter
        
        ownerNameField.placeholder = "fullname".localized()
        ownerNameField.font = FontConstants.bold?.withSize(16)
        ownerNameField.textColor = ColorConstants.textBlack
        ownerNameField.selectedTitleColor = ColorConstants.orange
        ownerNameField.selectedLineColor = ColorConstants.orange
        ownerNameField.titleFormatter = titleFormatter
        
        cnicField.placeholder = "cnic".localized()
        cnicField.font = FontConstants.bold?.withSize(16)
        cnicField.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        cnicField.selectedTitleColor = ColorConstants.orange
        cnicField.selectedLineColor = ColorConstants.orange
        cnicField.titleFormatter = titleFormatter
        cnicField.text = LocalStorage.getUserInfo()?.cnic
        cnicField.isUserInteractionEnabled = false
        
        addressField.placeholder = "address".localized()
        addressField.font = FontConstants.bold?.withSize(16)
        addressField.textColor = ColorConstants.textBlack
        addressField.selectedTitleColor = ColorConstants.orange
        addressField.selectedLineColor = ColorConstants.orange
        addressField.titleFormatter = titleFormatter
        
        continueButton.backgroundColor = ColorConstants.orange
        continueButton.setTitle("requestMtag".localized(), for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.setTitleColor(ColorConstants.white, for: .normal)
        continueButton.titleLabel?.font = FontConstants.regular?.withSize(16)
                
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "requestNewMtag".localized()
        
        scrollView.backgroundColor = ColorConstants.white
        
        scanCarLabel.font = FontConstants.bold?.withSize(16)
        scanCarLabel.textColor = ColorConstants.textGray
        scanCarLabel.text = "scanCar".localized()
        
        scanCnicLabel.font = FontConstants.bold?.withSize(16)
        scanCnicLabel.textColor = ColorConstants.textGray
        scanCnicLabel.text = "scanCnic".localized()
        
        scanVehicleDocLabel.font = FontConstants.bold?.withSize(16)
        scanVehicleDocLabel.textColor = ColorConstants.textGray
        scanVehicleDocLabel.text = "scanCarDoc".localized()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        var isFormValid = true
        if makeField.text == "" {
            makeField.errorColor = ColorConstants.red
            makeField.errorMessage = "enterMake".localized()
            isFormValid = false
        }
        if mobileNumberField.text == "" {
            mobileNumberField.errorColor = ColorConstants.red
            mobileNumberField.errorMessage = "enterPhone".localized()
            isFormValid = false
        }
        if vehicleTypeField.text == "" {
            vehicleTypeField.errorColor = ColorConstants.red
            vehicleTypeField.errorMessage = "enterVehicleType".localized()
            isFormValid = false
        }
        if !(cnicField.text?.isValidCnic() ?? false) {
            cnicField.errorColor = ColorConstants.red
            cnicField.errorMessage = "enterCnic".localized()
            isFormValid = false
        }
        if registrationNumField.text != "" {
            if !registrationNumField.text!.isAlphanumeric {
                registrationNumField.errorColor = ColorConstants.red
                registrationNumField.errorMessage = "enterRegnum".localized()
                isFormValid = false
            }
        } else {
            registrationNumField.errorColor = ColorConstants.red
            registrationNumField.errorMessage = "enterRegnum".localized()
            isFormValid = false
        }
        if ownerNameField.text == "" {
            ownerNameField.errorColor = ColorConstants.red
            ownerNameField.errorMessage = "enterOwnerName".localized()
            isFormValid = false
        }
        if addressField.text == "" {
            addressField.errorColor = ColorConstants.red
            addressField.errorMessage = "enteraddress".localized()
            isFormValid = false
        }
        if !cnicFrontAdded && isFormValid {
            Helper.showAlert("missingImage".localized(), message: "addImageCnicFront".localized(), controller: self)
            isFormValid = false
        }
        if !cnicBackAdded && isFormValid {
            Helper.showAlert("missingImage".localized(), message: "addImageCnicBack".localized(), controller: self)
            isFormValid = false
        }
        if !carFrontAdded && isFormValid {
            Helper.showAlert("missingImage".localized(), message: "addImageCarFront".localized(), controller: self)
            isFormValid = false
        }
//        if !carBackAdded && isFormValid {
//            Helper.showAlert("missingImage".localized(), message: "addImageCarBack".localized(), controller: self)
//            isFormValid = false
//        }
//        if !carDocAdded && isFormValid {
//            Helper.showAlert("missingImage".localized(), message: "addCarDoc".localized(), controller: self)
//            isFormValid = false
//        }
        if isFormValid {
            requestMtag()
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
        } else if textField == registrationNumField {
            if string.isAlphanumeric || string == "" {
                if (registrationNumField?.text?.count ?? 0) < 10 {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        else {
            return true
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Router.pop(from: self)
    }
    
    @IBAction func removeError(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = nil
    }
    
    @objc func carFront(tapGestureRecognizer: UITapGestureRecognizer) {
        currentImageTapped = .carFront
        handleImageTap(sourceView: carFrontImageView)
    }
    
    @objc func carBack(tapGestureRecognizer: UITapGestureRecognizer) {
        currentImageTapped = .carBack
        handleImageTap(sourceView: carBackImageView)
    }
    
    @objc func cnicFront(tapGestureRecognizer: UITapGestureRecognizer) {
        currentImageTapped = .cnicFront
        handleImageTap(sourceView: cnicFrontImageView)
    }
    
    @objc func cnicBack(tapGestureRecognizer: UITapGestureRecognizer) {
        currentImageTapped = .cnicBack
        handleImageTap(sourceView: cnicBackImageView)
    }
    
    @objc func carDoc(tapGestureRecognizer: UITapGestureRecognizer) {
        currentImageTapped = .carDoc
        handleImageTap(sourceView: carDocImageView)
    }
    
    func handleImageTap(sourceView: UIView?) {
        if let topViewController = UIApplication.topViewController() {
            Helper.showAlertWithThreeButton("", message: "uploadFrom".localized(), style: .actionSheet, buttonTitleOne: "camera".localized(), buttonTitleTwo: "photos".localized(), controller: topViewController, ipadSourceView: sourceView, handlerOne: {_ in
                self.openCamera()
            }, handlerTwo: {_ in
                self.openPhotos()
            })
        }
    }
    
    func openCamera() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            if let vc = UIApplication.topViewController() {
                chooseFromPhotos = false
                Router.presentImagePickerView(from: vc, imagePicker: imagePicker)
            }
        } else {
            if let topViewController = UIApplication.topViewController() {
                Helper.showAlert("Alert".localized(), message: "No camera found", controller: topViewController)
            }
        }
    }
    
    func openPhotos() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            if let vc = UIApplication.topViewController() {
                chooseFromPhotos = true
                Router.presentImagePickerView(from: vc, imagePicker: imagePicker)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        UIApplication.topViewController()?.dismiss(animated: true)
        let item = MediaItem(image: newImage)
        let waterMarkString = "watermark".localized()
        let attributes = [ NSAttributedString.Key.foregroundColor: ColorConstants.orange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 75, weight: .ultraLight) ]
        let attrStr = NSAttributedString(string: waterMarkString, attributes: attributes)
                
        let waterMarkElement1 = MediaElement(text: attrStr)
        waterMarkElement1.frame = CGRect(x: 20, y: 20, width: newImage.size.width, height: newImage.size.height)
        let waterMarkElement2 = MediaElement(text: attrStr)
        waterMarkElement2.frame = CGRect(x: 20, y: newImage.size.height / 2, width: newImage.size.width, height: newImage.size.height)
        let waterMarkElement3 = MediaElement(text: attrStr)
        waterMarkElement3.frame = CGRect(x: 20, y: newImage.size.height - 50, width: newImage.size.width, height: newImage.size.height)
        item.add(elements: [waterMarkElement1, waterMarkElement2, waterMarkElement3])
        let mediaProcessor = MediaProcessor()
        mediaProcessor.processElements(item: item) { (result, error) in
            if let watermarkedImage = result.image {
                newImage = watermarkedImage
            }
        }
        switch currentImageTapped {
        case .carFront:
            carFrontImageView.image = newImage
            carFrontAdded = true
        case .carBack:
            carBackImageView.image = newImage
            carBackAdded = true
        case .cnicFront:
            cnicFrontImageView.image = newImage
            cnicFrontAdded = true
        case .cnicBack:
            cnicBackImageView.image = newImage
            cnicBackAdded = true
        case .carDoc:
            carDocImageView.image = newImage
            carDocAdded = true
        }
    }
}

extension RequestMtagViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicleTypes.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicleTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vehicleTypeSelected = vehicleTypeApi[row]
        vehicleTypeField.text = vehicleTypes[row]
    }
}

extension RequestMtagViewController {
    func requestMtag() {
        continueButton.showLoading()
        self.view.isUserInteractionEnabled = false
        network.uploadMultiPart("requestMtag",
                                method: .post,
                                parameters: ["fullName":ownerNameField.text!,
                                             "mobileNumber":mobileNumberField.text!,
                                             "address":addressField.text!,
                                             "cnicNumber":cnicField.text!,
                                             "vehicleType":vehicleTypeSelected,
                                             "vehicleMakeModel":makeField.text!,
                                             "vehicleRegistrationNumber":registrationNumField.text!],
                                encoding: URLEncoding.default,
                                headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                          "Content-Type":"application/json"],
                                modelType: RequestMtagResponseModel.self,
                                CnicFrontPicture: carFrontImageView.image!,
                                CnicBackPicture: carBackImageView.image!,
                                carFrontPicture: carFrontImageView.image!,
                                success: { (response) in
            self.continueButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            if let responseObject = response as? RequestMtagResponseModel {
                if responseObject.Code == "00" {
                    Router.showMTagRequestPopUp(from: self)
                }
            }
        },
                                failure: { (error) in
            self.continueButton.hideLoading()
            self.view.isUserInteractionEnabled = true
            
            
            if (error?.code ?? 400) > 499 {
                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }else{
                Helper.showAlert("Alert".localized(), message: error?.localizedDescription ?? "general_error".localized(), controller: self)
            }
            
            
        })
    }
}
