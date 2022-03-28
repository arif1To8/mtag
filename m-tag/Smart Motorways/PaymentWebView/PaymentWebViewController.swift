//
//  PaymentWebViewController.swift
//  Smart Motorways
//
//  Created by Kaleem Asad on 11/25/21.
//

import UIKit
import WebKit

class PaymentWebViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var backgroundView: UIView!
    var orderID: String!
    var cnic: String!
    var amount: String!
    var mTagToken: String!
    var bearerToken: String!
    weak var delegate: PaymentProtocol?
    var activityIndicator: UIActivityIndicatorView!
    private var paymentWebView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //todo move this code
        

        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        paymentWebView = WKWebView(frame: view.bounds, configuration: configuration)
        paymentWebView.scrollView.setZoomScale(2.0, animated: true)
        backgroundView.addSubview(paymentWebView)
        
        paymentWebView.uiDelegate = self
        paymentWebView.navigationDelegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width/2)-22, y: 200, width: 44, height: 44))
        paymentWebView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: paymentWebView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: paymentWebView.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        

        bearerToken = bearerToken.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
       
//URL FOR TESTING        let paymentURL = "https://fwosmartmotorways.com/PaymentApi/alfa_test/index.php?order_id=\(self.orderID!)&amount=\(amount!)&itokenno=\(mTagToken!)&currency=PKR&cnicno=\(cnic!)"
        let phoneNumber = LocalStorage.getUserInfo()?.mobileNumber ?? ""
        
        let paymentURL = "https://fwosmartmotorways.com/PaymentApi/alfa/index.php?order_id=\(self.orderID!)&amount=\(amount!)&itokenno=\(mTagToken!)&currency=PKR&cnicno=\(cnic!)&mobilenumber=\(phoneNumber)&mobiletype=2"
        var urlRequest = URLRequest(url: URL(string: paymentURL)!)
        urlRequest.httpMethod = "POST"
        paymentWebView.load(urlRequest)
        paymentWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
     
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func backPressed(_ sender: Any) {
        delegate?.paymentResponse(controller: self, status: "cancel", message: "Payment cancelled")
    }
    
    //helper method to build url form request
    func getPostString(params:[String:String]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
            
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let key = change?[NSKeyValueChangeKey.newKey] {
            print("observeValue \(key)") // url value
            if let resUrlQuery = URL(string: "\(key)") {
                let resUrlQueryParams = resUrlQuery.params()
                guard let status = resUrlQueryParams["status"] as? String, let msg = resUrlQueryParams["msg"] as? String else { return }
                print(resUrlQueryParams)
                if ((status == "success" || status == "cancel" || status == "error") && (msg != "Unknown")){
                    delegate?.paymentResponse(controller: self, status: status, message: msg)
                }
            }
        }
        
        
//        if let key = change?[NSKeyValueChangeKey.newKey] {
//            print("observeValue \(key)") // url value
//            let resUrlQueryParams = (key as! URL).params()
//            guard let status = resUrlQueryParams["status"] as? String, let msg = resUrlQueryParams["msg"] as? String else { return }
//            print(resUrlQueryParams)
//            if ((status == "success" || status == "cancel" || status == "error") && (msg != "Unknown")){
//                delegate?.paymentResponse(controller: self, status: status, message: msg)
//
//            }
//        }
    }
}


extension PaymentWebViewController: WKUIDelegate, WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        activityIndicator.stopAnimating()

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        delegate?.paymentResponse(controller: self, status: "cancel", message: "Payment cancelled")
    }

    
    
}


//TODO: Move all extensions to extension files
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}


extension URL {
    func params() -> [String:Any] {
        var dict = [String:Any]()
        
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    dict[item.name] = item.value!
                }
            }
            return dict
        } else {
            return [:]
        }
    }
}


protocol PaymentProtocol: AnyObject {
    func paymentResponse(controller: PaymentWebViewController,status: String, message: String)
}
