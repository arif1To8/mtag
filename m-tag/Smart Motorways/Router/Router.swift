//
//  Router.swift
//  AddMee
//
//  Created by Abdul Wahab on 11/04/2021.
//

import UIKit

class Router {
    
    static func showVerification(from currentVC: UIViewController, accessToken: String, cnic: String, mobile: String, isLogin: Int) {
        let vc = VerificationViewController.instantiate(storyBoardName: "Verification")
        vc.accessToken = accessToken
        vc.cnic = cnic
        vc.mobile = mobile
        vc.isLogin = isLogin
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func pop(from currentVC: UIViewController) {
        currentVC.navigationController?.popViewController(animated: true)
    }
    
    static func showLoginAsRootVC() {
        let vc = LoginViewController.instantiate(storyBoardName: "Login")
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    static func showHomeScreenAsRootVC() {
        let vc = HomeScreenViewController.instantiate(storyBoardName: "HomeScreen")
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
//        UIView.transition(with: UIApplication.shared.windows.first!,
//                              duration: 0.3,
//                              options: .transitionCrossDissolve,
//                              animations: nil,
//                              completion: nil)
    }
    
    static func showPopUp(from currentVC: UIViewController, requestAction: @escaping (() -> ()), addBalanceAction: @escaping (() -> ())) {
        let vc = AddPopUpViewController.instantiate(storyBoardName: "AddPopUp")
        vc.modalPresentationStyle = .overCurrentContext
        vc.requestPressedAction = requestAction
        vc.addBalancePressedAction = addBalanceAction
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    static func showMtagRequest(from currentVC: UIViewController) {
        let vc = RequestMtagViewController.instantiate(storyBoardName: "RequestMtag")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showWebView(from currentVC: UIViewController, with link: String) {
        let vc = GenericWebViewController.instantiate(storyBoardName: "GenericWebView")
        vc.urlString = link
        currentVC.navigationController?.pushViewController(vc, animated: false)
    }
    
    static func showAddBalance(from currentVC: UIViewController) {
        let vc = AddBalanceViewController.instantiate(storyBoardName: "AddBalance")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func presentImagePickerView(from controller: UIViewController, imagePicker: UIImagePickerController) {
        controller.present(imagePicker, animated: true, completion: nil)
    }
    
    static func showMTagRequestPopUp(from currentVC: UIViewController) {
        let vc = RequestMtagPopUpViewController.instantiate(storyBoardName: "RequestMtagPopUp")
        vc.modalPresentationStyle = .overCurrentContext
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    static func showVehicleDetail(from currentVC: UIViewController, detail: MtagDetailsObject) {
        let vc = VehicleDetailViewController.instantiate(storyBoardName: "VehicleDetail")
        vc.detail = detail
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showProfile(from currentVC: UIViewController) {
        let vc = ProfileViewController.instantiate(storyBoardName: "Profile")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showTollCharges(from currentVC: UIViewController) {
        let vc = TollChargesViewController.instantiate(storyBoardName: "TollCharges")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showFeedback(from currentVC: UIViewController) {
        let vc = AddFeedbackViewController.instantiate(storyBoardName: "AddFeedback")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showFeedbackList(from currentVC: UIViewController) {
        let vc = FeedbackListViewController.instantiate(storyBoardName: "FeedbackList")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showRegistration(from currentVC: UIViewController) {
        let vc = RegisterViewController.instantiate(storyBoardName: "Register")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showTransactionHistory(from currentVC: UIViewController, mtagDetailList: [MtagDetailsObject], mtagID: String = "") {
        let vc = TransactionHistoryViewController.instantiate(storyBoardName: "TransactionHistory")
        vc.mtagDetailList = mtagDetailList
        vc.mtagID = mtagID
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showActiveMtags(from currentVC: UIViewController) {
        let vc = ActiveMtagsViewController.instantiate(storyBoardName: "ActiveMtags")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showRechargeMtags(from currentVC: UIViewController, mtagDetailList: [MtagDetailsObject], openFromVehicleDetail: Bool) {
        
//        if (mtagDetailList.count > 0){
        let vc = RechargeMtagViewController.instantiate(storyBoardName: "RechargeMtag")
        vc.mtagDetailList = mtagDetailList
        vc.openFromVehicle = openFromVehicleDetail
        currentVC.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//            Helper.showAlert("error".localized(), message: "No M-Tag Available", controller: currentVC)
//        }
    }
    
    static func showPaymentView(from currentVC: UIViewController, amount: String, mTagToken: String) {
        let vc = PaymentWebViewController.instantiate(storyBoardName: "PaymentWebView")
        
        let timeStamp = "RVP00\(mTagToken)\(NSDate().timeIntervalSince1970 * 1000000)"
        let orderID = String(timeStamp.prefix(18))
        vc.orderID = orderID
        vc.cnic = LocalStorage.getUserInfo()?.cnic
        vc.amount = amount
        vc.mTagToken = mTagToken
        vc.bearerToken = LocalStorage.getAccessToken()
        vc.delegate = currentVC as? PaymentProtocol
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    static func showPendingMtagList(from currentVC: UIViewController, pendingMtagList: [PendingMtagObject]) {
        let vc = PendingMtagListViewController.instantiate(storyBoardName: "PendingMtagList")
        vc.pendingMtagList = pendingMtagList
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showTollCalculator(from currentVC: UIViewController) {
        let vc = TollCalculatorViewController.instantiate(storyBoardName: "TollCalculator")
        currentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showHistoryFilterPopUp(from currentVC: UIViewController, mtags: [MtagDetailsObject], callback: @escaping ((String,String,String) -> ())) {
        let vc = HistoryFilterViewController.instantiate(storyBoardName: "HistoryFilter")
        vc.mtags = mtags
        vc.callbackAction = callback
        vc.modalPresentationStyle = .overCurrentContext
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    static func showDelinkActiveTagPopUp(from currentVC: UIViewController, mtagDetailObj: MtagDetailsObject, callback: @escaping((String, MtagDetailsObject) -> ())) {
        let vc = deletePermissionPopUp.instantiate(storyBoardName: "deletePermissionPopUp")
        vc.tagDetailObj = mtagDetailObj
        vc.callbackAction = callback
        vc.modalPresentationStyle = .overCurrentContext
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    static func showUpdatePopUp(from currentVC: UIViewController, desc: String) {
        let vc = updatePopUp.instantiate(storyBoardName: "updatePopUp")
        vc.modalPresentationStyle = .overCurrentContext
        vc.desc = desc
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    static func showPendingMtagDetailPopUp(from currentVC: UIViewController, detail: PendingMtagObject) {
        let vc = PendingMtagDetailPopupViewController.instantiate(storyBoardName: "PendingMtagDetailPopup")
        vc.detail = detail
        vc.modalPresentationStyle = .overCurrentContext
        currentVC.navigationController?.present(vc, animated: false, completion: nil)
    }
    
   
    
}
