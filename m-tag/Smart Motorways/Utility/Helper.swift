//
//  Helper.swift
//  AddMee
//
//  Created by Abdul Wahab on 12/04/2021.
//

import Foundation
import UIKit
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
}

public class Helper {
    
    public class func getDeviceInformation() -> String{
        //        platform_osversion_brandmodel_deviceid_countrycode
        let platform = "ios"
        let osVersion = UIDevice.current.systemVersion
//        let brandModel = UIDevice.current.model
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.standard.setValue(deviceId, forKey: "device_id")
        //        5E1AEC4F-A8F8-4F31-9248-534CB3671AB0
        let finalString = "\(platform)__\(osVersion)__\(UIDevice.current.name)__\(deviceId)"
//        "ios__15.3__iPhone 12__FE2DCE8C-CD8A-4BA1-8FE7-54B4949C4C4A"
        return finalString
        
    }
    
    
    
    public class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public class func showAlert(_ title: String, message: String, controller: UIViewController?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: UIAlertAction.Style.default, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    public class func showAlertWithOneButton(_ title: String, message: String, buttonTitle: String, controller: UIViewController?, action: @escaping ((UIAlertAction) -> ())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    
    public class func showAlertWithTwoButton(_ title: String, message: String, style: UIAlertController.Style = .alert, buttonTitleOne: String, buttonTitleTwo: String, controller: UIViewController?, handlerOne: ((UIAlertAction) -> ())?, handlerTwo: ((UIAlertAction) -> ())?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
            alert.addAction(UIAlertAction(title: buttonTitleOne, style: .default, handler: handlerOne))
            alert.addAction(UIAlertAction(title: buttonTitleTwo, style: .default, handler: handlerTwo))
        
            controller?.present(alert, animated: true, completion: nil)
        }
    
    public class func showAlertWithThreeButton(_ title: String, message: String, style: UIAlertController.Style = .alert, buttonTitleOne: String, buttonTitleTwo: String, controller: UIViewController?, ipadSourceView: UIView? = nil, handlerOne: ((UIAlertAction) -> ())?, handlerTwo: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: buttonTitleOne, style: .default, handler: handlerOne))
        alert.addAction(UIAlertAction(title: buttonTitleTwo, style: .default, handler: handlerTwo))
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: {_ in alert.dismiss(animated: true, completion: nil)}))
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = ipadSourceView
            }
        }
        controller?.present(alert, animated: true, completion: nil)
    }
    
    public class func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    public class func isTokenValid() -> Bool {
        guard let tokenTime = LocalStorage.getSecondsTokenReceived() else { return false }
        let currentTime = Int(Date.timeIntervalSinceReferenceDate)
        if (currentTime - tokenTime) > Constants.tokenExpiryLimit {
            return false
        } else {
            return true
        }
    }

    public class func vehicleType(from code: String) -> String {
        switch code {
        case "F1":
            return "Car"
        case "F2":
            return "Wagon"
        case "F3":
            return "Coaster"
        case "F4":
            return "Bus"
        case "F5":
            return "Truck 2/3 Axle"
        case "F6":
            return "Trailer"
        default:
            return "N/A"
        }
    }
    
    public class func vehicleCode(from type: String) -> String {
        switch type {
        case "Car":
            return "F1"
        case "Wagon":
            return "F2"
        case "Coaster":
            return "F3"
        case "Bus":
            return "F4"
        case "Truck 2/3 Axle":
            return "F5"
        case "Trailer":
            return "F6"
        default:
            return "N/A"
        }
    }
    
    public class func vehicleID(from type: String) -> Int {
        switch type {
        case "Car":
            return 1
        case "Wagon":
            return 2
        case "Coaster":
            return 3
        case "Bus":
            return 4
        case "Truck 2/3 Axle":
            return 5
        case "Trailer":
            return 6
        default:
            return 0
        }
    }
    
    
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    static func moveToAppstore(){
        if let url = URL(string: "itms-apps://apple.com/app/id1574366732") {
            UIApplication.shared.open(url)
        }
    }
}

 
