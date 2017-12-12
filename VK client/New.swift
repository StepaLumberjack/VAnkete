//
//  New.swift
//  VK client
//
//  Created by macbookpro on 25.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
//import RealmSwift

class New {
    //@objc dynamic
    var newsImageUrl: String?
    //@objc dynamic
    var newsText = ""
    var id = 0
    var sourceId = 0
    var friend: Friend?
    var group: Group?
    
//    convenience init (json: JSON) {
//        self.init()
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.newsText = json["text"].stringValue
//            let attach = json["attachments"] as? [[String: Any]] ?? [["cyka":"blyat"]]
//            for j in attach {
//                if j["type"] as? String ?? "fuck" == "photo" {
//                    let enterPhoto = j["photo"] as? [String: Any] ?? ["cyka":"blyat"]
//                    self.newsImageUrl = enterPhoto["photo_130"] as? String ?? "fuck"
//                }
//            }
//        }
//    }
}
