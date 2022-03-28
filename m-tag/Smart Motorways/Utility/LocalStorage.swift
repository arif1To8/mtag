//
//  LocalStorage.swift
//  AddMee
//
//  Created by Abdul Wahab on 12/04/2021.
//

import Foundation

open class LocalStorage: NSObject {
    
    public static func getAccessToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.AccessToken) ?? ""
    }
    
    public static func getSignupAccessToken() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.signupAccessToken) ?? ""
    }
    
    public static func getBiometricCnic() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.biometricCnic) ?? ""
    }
    
    public static func getBiometricMobile() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.biometricMobile) ?? ""
    }
    
    public static func saveAccessTokenObject(accessToken: String) {
        UserDefaults.standard.setValue(accessToken, forKey: UserDefaultKeys.AccessToken)
        UserDefaults.standard.synchronize()
    }
    
    public static func saveSignupAccessTokenObject(accessToken: String) {
        UserDefaults.standard.setValue(accessToken, forKey: UserDefaultKeys.signupAccessToken)
        UserDefaults.standard.synchronize()
    }
    
    public static func saveCNICforBiometric(cnic: String) {
        UserDefaults.standard.setValue(cnic, forKey: UserDefaultKeys.biometricCnic)
        UserDefaults.standard.synchronize()
    }
    
    public static func saveMobileforBiometric(mobile: String) {
        UserDefaults.standard.setValue(mobile, forKey: UserDefaultKeys.biometricMobile)
        UserDefaults.standard.synchronize()
    }
    
    public static func saveTimeForToken() {
        let seconds = Int(Date.timeIntervalSinceReferenceDate)
        UserDefaults.standard.setValue(seconds, forKey: UserDefaultKeys.secondsWhenReceivedToken)
        UserDefaults.standard.synchronize()
    }
    
    public static func getUserInfo() -> CustomerDetailObject? {
        return UserDefaults.standard.getCustomObject(UserDefaultKeys.UserInfo)
    }
    
    public static func getSecondsTokenReceived() -> Int? {
        return UserDefaults.standard.integer(forKey: UserDefaultKeys.secondsWhenReceivedToken)
    }
    
    public static func saveUserInfoObject(userInfo: CustomerDetailObject) {
        UserDefaults.standard.setCustomObject(userInfo, forKey: UserDefaultKeys.UserInfo)
        UserDefaults.standard.synchronize()
    }
    
    public static func updateUserInfoObject(userInfo: CustomerDetailObject) {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.UserInfo)
        UserDefaults.standard.setCustomObject(userInfo, forKey: UserDefaultKeys.UserInfo)
        UserDefaults.standard.synchronize()
    }
    
    public static func clearToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.AccessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.UserInfo)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.secondsWhenReceivedToken)
        UserDefaults.standard.synchronize()
    }
    
    public static func clearBiometric() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.biometricMobile)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.biometricCnic)
        UserDefaults.standard.synchronize()
    }
}
