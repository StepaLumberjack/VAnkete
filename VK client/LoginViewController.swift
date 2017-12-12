//
//  LoginViewController.swift
//  VK client
//
//  Created by macbookpro on 30.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView! {
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    var service = VKLoginService()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.load(service.getrequest())
        // Do any additional setup after loading the view.
    }

}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce ([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        let token = params["access_token"]
        globalID = params["user_id"] ?? "0"
        userDefaults.set(token, forKey:"token")
        
        globalToken = token!
        decisionHandler(.cancel)
        
        if userDefaults.string(forKey: "token") != nil {
            performSegue(withIdentifier: "successAuthorization", sender: token)
            let entity = AuthenticatedUser(id: globalID, enteredGroups: [])
            let data = [entity].reduce([String: Any]()) { (prevResult, authenticatedUser) in
                var prevResult = prevResult
                prevResult[authenticatedUser.id] = authenticatedUser.toAnyObject
                return prevResult
            }
            let dbLink = Database.database().reference()
            dbLink.child("Authenticated users").setValue(data)
        }
    }
}

var globalToken: String = ""
var globalID: String = ""
