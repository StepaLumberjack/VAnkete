//
//  TBVC.swift
//  VK client
//
//  Created by macbookpro on 30.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class TBVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

        // Do any additional setup after loading the view.
    }

}

let configuration = URLSessionConfiguration.default
let sessionManagerG = SessionManager(configuration: configuration)
