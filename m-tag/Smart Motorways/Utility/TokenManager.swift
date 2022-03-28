////
////  TokenManager.swift
////  AddMee
////
////  Created by Abdul Wahab on 12/04/2021.
////
//
//import Foundation
//
//enum TokenStatus {
//    case valid
//    case invalid
//    case updating
//}
//
//class TokenManager {
//
//    let networkManager = NetworkManager()
//    var tokenStatus: TokenStatus = .valid
//
//    func getNewAccessToken(success: @escaping () -> ()) {
//        if !isTokenValid() {
//            tokenStatus = .updating
//            initiateTokenRequest(success: success)
//        }
//    }
//
//    static func setTokenTime(secondsValidFor: Int) {
//        let seconds = Int(Date.timeIntervalSinceReferenceDate)
//        LocalStorage.saveSecondsWhenTokenReceived(seconds: seconds)
//        LocalStorage.saveTokenExpiryLimit(secondsValidFor: secondsValidFor)
//    }
//
//    private func secondsWhenTokenReceived() -> Int {
//        return LocalStorage.getSecondsWhenTokenReceived()
//    }
//
//    private func secondsSinceTokenReceived() -> Int {
//        return Int(Date.timeIntervalSinceReferenceDate) - secondsWhenTokenReceived()
//    }
//
//    func isTokenValid() -> Bool {
//        return !(secondsSinceTokenReceived() >= LocalStorage.getTokenExpiryLimit())
//    }
//
//    private func initiateTokenRequest(success: @escaping () -> ()) {
//        let requestUrl: String = EndPoints.accessToken
//        self.networkManager
//            .request(requestUrl,
//                     method: .post,
//                     parameters: ["grant_type":"refresh_token",
//                                  "client_id":AppConfig.clientId(),
//                                  "refresh_token":LocalStorage.getRefreshToken()],
//                     modelType: AccessToken.self,
//                     success: { (responseObject) in
//                        let accessToken = responseObject as? AccessToken
//                        print(accessToken?.accessToken ?? "")
//                        if let accessToken = accessToken {
//                            LocalStorage.saveAccessTokenObject(accessToken: accessToken)
//                            self.tokenStatus = .valid
//                            success()
//                        } else {
//                            self.tokenStatus = .invalid
//                            if let topController = UIApplication.topViewController() {
//                                Helper.showAlert("error".localized(), message: "error_message_unexpected_behaviour".localized(), controller: topController)
//                            }
//                            return
//                        }
//                     }, failure: { (error) in
//                        self.tokenStatus = .invalid
//                        if ((error?.userInfo[ErrorCodes.networkError]) != nil) {
//                            if let topController = UIApplication.topViewController() {
//                                Helper.showAlert("error".localized(), message: error?.localizedDescription ?? "error_message_connectivity".localized(), controller: topController)
//                            }
//                        } else {
//                            LocalStorage.clearToken()
//                            if let topController = UIApplication.topViewController() {
//                                Helper.showAlertWithOneButton("error".localized(), message: "please_sign_in_again_alert_msg".localized(), buttonTitle: "ok".localized(), controller: topController, action: {_ in
//                                    Router.showLoginScreenFromRootVC()
//                                })
//                            } else {
//                                Router.showLoginScreenFromRootVC()
//                            }
//                        }
//                     })
//    }
//
//}
