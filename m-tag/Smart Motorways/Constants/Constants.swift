//
//  Constants.swift
//  AddMee
//
//  Created by Abdul Wahab on 15/04/2021.
//

struct HeaderConstants {
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let contentType = "Content-Type"
    static let acceptValue = "application/json"
    static let contentTypeValue = "application/x-www-form-urlencoded"
}

struct UserDefaultKeys {
    static let AccessToken = "AccessToken"
    static let signupAccessToken = "SignupAccessToken"
    static let UserInfo = "UserInfo"
    static let secondsWhenReceivedToken = "seconds"
    static let biometricCnic = "biometricCnic"
    static let biometricMobile = "biometricMobile"
}

struct ApiConstants {
//    static let url = "http://115.186.178.138:8880/"
    static let url = "https://onenetworkapp.com/"  //live base url
//    static let url = "http://115.186.178.138:8881/" // testing environment
//    static let urlWithoutSlash = "http://115.186.178.138:8880"
    static let host = ""
}
struct loginConstant {
    static var openFromLogin = false
    
}

struct ErrorCodes {
    static let networkError = "networkError"
    static let errorMessage = "errorMessage"
}

struct Constants {
    static let tokenExpiryLimit = 3540
    static let secondsInADay = 86400
}

struct MtagGlobal {
    static let list: [String] = []
}

struct smsMessage {
    static let text = "Your authentication code for M-TAG One Network app is VERIFICATION_CODE_HERE. Never share it with anyone, ever."
}

struct mobilePreFix {
    static let value = "03"
}
