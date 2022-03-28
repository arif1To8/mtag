//
//  GenericWebViewController.swift
//  AddMee
//
//  Created by Abdul Wahab on 13/04/2021.
//

import UIKit
import WebKit

class GenericWebViewController: UIViewController, WKNavigationDelegate, Storyboarded {
    
    var webView: WKWebView!
    public var urlString: String!
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString)!
        setToolBar()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 13.0, *) {
            webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    fileprivate func setToolBar() {
        let screenWidth = self.view.bounds.width
        let backButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(goBack))
        backButton.tintColor = ColorConstants.orange
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [backButton]
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width/2)-22, y: 200, width: 44, height: 44))
        webView.addSubview(toolBar)
        webView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
      }
      @objc private func goBack() {
        Router.pop(from: self)
      }

}
