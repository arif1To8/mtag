//
//  NetworkManager.swift
//  AddMee
//
//  Created by Abdul Wahab on 12/04/2021.
//

import Foundation
import Alamofire

/**
 NetworkManager class is the layer which is responbile for all type of network communication of application.
 */

class NetworkManager : NSObject {
    
    func request<T: Decodable>(_ endPoint: String,
                               method: HTTPMethod = .get,
                               parameters: Parameters? = nil,
                               encoding: ParameterEncoding = URLEncoding.default,
                               headers: HTTPHeaders? = nil,
                               modelType: T.Type = EmptyModel.self as! T.Type,
                               success: @escaping (_ result: Any?) -> Void,
                               failure: @escaping (_ error: NSError?) -> Void) {
        
        
        let isAuthTokenNeeded = headers?[HeaderConstants.authorization] != nil
        let url = "\(ApiConstants.url)\(endPoint)"
        let performRequest: () -> () = {
            let redirector = Redirector(behavior: .modify({ (task, request, response) -> URLRequest? in 
                var redirectedRequest = request
                
                if let originalRequest = task.originalRequest,
                   let headers = originalRequest.allHTTPHeaderFields,
                   let authorizationHeaderValue = headers[HeaderConstants.authorization] {
                    var mutableRequest = request
                    mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: HeaderConstants.authorization)
                    redirectedRequest = mutableRequest
                }
                return redirectedRequest
            }))
            
            var mutatedHeaders = headers
            if (endPoint != "verifyOTP") && (endPoint != "generateOTP_6") {
                mutatedHeaders?.remove(name: HeaderConstants.authorization)
                mutatedHeaders?.add(name: HeaderConstants.authorization, value: "Bearer \(LocalStorage.getAccessToken())")
            }
            
            print("MUTATED HEADERS: \(mutatedHeaders)")
            print("HEADERS: \(headers)")
            
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: isAuthTokenNeeded ? mutatedHeaders : headers)
            
            if modelType == EmptyModel.self {
                request.validate()
                    .redirect(using: redirector)
                    .response { (response) in
                        switch response.result {
                        case .success(let responseObject):
                            success(responseObject)
                        case .failure(let error):
                            failure(self.handleError(error, responseData: response.data))
                        }
                    }
            } else {
                request.validate()
                    .redirect(using: redirector)
                    .responseDecodable(of: T.self) { (response) in
                        switch response.result {
                        case .success(let responseObject):
                            success(responseObject)
                        case .failure(let error):
                            failure(self.handleError(error, responseData: response.data))
                        }
                    }
            }
        }
        performRequest()
        
//        if isAuthTokenNeeded {
//            if Helper.isTokenValid() {
//                performRequest()
//                            } else {
//                self.refreshTokenAndContinue(successAction: {
//                    performRequest()
//                })
//            }
//        } else {
//            performRequest()
//        }
        
    }
}

extension NetworkManager {
    func handleError(_ error: AFError, responseData: Data?) -> NSError {
        
        var errorResponseBody:[String:Any]?
        if let data = responseData {
            let json = String(data: data, encoding: String.Encoding.utf8)
            errorResponseBody = Helper.convertToDictionary(text: json ?? "")
        }
        
        var userInfo:[String : Any] = [:]
        switch error.responseCode ?? 0 {
        case 400..<500:
            userInfo[NSLocalizedDescriptionKey] = errorResponseBody?["Message"]
        case 500..<600:
            userInfo[NSLocalizedDescriptionKey] = errorResponseBody?["Message"]
        default:
            if errorResponseBody?["Message"] != nil && errorResponseBody?["Message"] as! String != "" {
                userInfo[NSLocalizedDescriptionKey] = errorResponseBody?["Message"]
            } else {
                userInfo[NSLocalizedDescriptionKey] = "general_error".localized()
            }
            if !(NetworkReachabilityManager()?.isReachable ?? false) {
                userInfo[NSLocalizedDescriptionKey] = "connectivity_error".localized()
                userInfo[ErrorCodes.networkError] = true
            }
        }
        
        if let errorResponseBody = errorResponseBody {
            userInfo = userInfo.merging(errorResponseBody) { (_, new) in new }
        }
        if let msg = errorResponseBody?["msg"] as? String{
            if msg == "Token has expired"{
                LocalStorage.clearToken()
                HomeScreenViewController.mtagDetailList = []
                Router.showLoginAsRootVC()
            }
        }
        
        return NSError(domain: "", code: error.responseCode ?? 0, userInfo: userInfo)
    }

    func refreshTokenAndContinue(successAction: @escaping (() -> ())) {
        self.refreshToken("refreshToken",
                          method: .post,
                          parameters: ["CnicNumber":LocalStorage.getUserInfo()?.cnic ?? "NoCnic"],
                          encoding: JSONEncoding.default,
                          modelType: LoginResponseModel.self,
                          success: { (response) in
                            if let response = response as? LoginResponseModel {
                                if let token = response.Data {
                                    LocalStorage.saveAccessTokenObject(accessToken: token)
                                    LocalStorage.saveTimeForToken()
                                    successAction()
                                } else {
                                    LocalStorage.clearToken()
                                    Router.showLoginAsRootVC()
                                }
                            } else {
                                LocalStorage.clearToken()
                                Router.showLoginAsRootVC()
                            }
                          },
                          failure: { (error) in
                            LocalStorage.clearToken()
                            Router.showLoginAsRootVC()
                          })
    }
    
    
    
    func refreshToken<T: Decodable>(_ endPoint: String,
                                    method: HTTPMethod = .get,
                                    parameters: Parameters? = nil,
                                    encoding: ParameterEncoding = URLEncoding.default,
                                    headers: HTTPHeaders? = nil,
                                    modelType: T.Type = EmptyModel.self as! T.Type,
                                    success: @escaping (_ result: Any?) -> Void,
                                    failure: @escaping (_ error: NSError?) -> Void) {
        
        let url = "\(ApiConstants.url)\(endPoint)"
        let performRequest: () -> () = {
            
            let redirector = Redirector(behavior: .modify({ (task, request, response) -> URLRequest? in
                var redirectedRequest = request
                
                if let originalRequest = task.originalRequest,
                   let headers = originalRequest.allHTTPHeaderFields,
                   let authorizationHeaderValue = headers[HeaderConstants.authorization] {
                    var mutableRequest = request
                    mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: HeaderConstants.authorization)
                    redirectedRequest = mutableRequest
                }
                return redirectedRequest
            }))
            
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers)
            
            if modelType == EmptyModel.self {
                request.validate()
                    .redirect(using: redirector)
                    .response { (response) in
                        switch response.result {
                        case .success(let responseObject):
                            success(responseObject)
                        case .failure(let error):
                            failure(self.handleError(error, responseData: response.data))
                        }
                    }
            } else {
                request.validate()
                    .redirect(using: redirector)
                    .responseDecodable(of: T.self) { (response) in
                        switch response.result {
                        case .success(let responseObject):
                            success(responseObject)
                        case .failure(let error):
                            failure(self.handleError(error, responseData: response.data))
                        }
                    }
            }
        }
        
        performRequest()
    }
}

extension NetworkManager {
    
    func uploadMultiPart<T: Decodable>(_ endPoint: String,
                                       method: HTTPMethod = .get,
                                       parameters: [String:String],
                                       encoding: ParameterEncoding = URLEncoding.default,
                                       headers: HTTPHeaders? = nil,
                                       modelType: T.Type = EmptyModel.self as! T.Type,
                                       CnicFrontPicture: UIImage,
                                       CnicBackPicture: UIImage,
                                       carFrontPicture: UIImage,
                                       success: @escaping (_ result: Any?) -> Void,
                                       failure: @escaping (_ error: NSError?) -> Void) {
        
        guard let imageData1 = CnicFrontPicture.jpegData(compressionQuality: 0.5) else {
            return
        }
        guard let imageData2 = CnicBackPicture.jpegData(compressionQuality: 0.5) else {
            return
        }
        //        guard let imageData3 = carRegistrationDoc.jpegData(compressionQuality: 0.5) else {
        //            return
        //        }
        guard let imageData4 = carFrontPicture.jpegData(compressionQuality: 0.5) else {
            return
        }
        //        guard let imageData5 = carBackPicture.jpegData(compressionQuality: 0.5) else {
        //            return
        //        }
        
        let url = "\(ApiConstants.url)\(endPoint)"
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData1, withName: "CnicFrontPicture" , fileName: "file.png", mimeType: "image/png")
                multipartFormData.append(imageData2, withName: "CnicBackPicture" , fileName: "file.png", mimeType: "image/png")
                //                multipartFormData.append(imageData3, withName: "carRegistrationDoc" , fileName: "file.png", mimeType: "image/png")
                multipartFormData.append(imageData4, withName: "carFrontPicture" , fileName: "file.png", mimeType: "image/png")
                //                multipartFormData.append(imageData5, withName: "carBackPicture" , fileName: "file.png", mimeType: "image/png")
                
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
            to: url, method: .post , headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let responseObject):
                    success(responseObject)
                case .failure(let error):
                    failure(self.handleError(error, responseData: response.data))
                }
            }
    }
}

