//
//  Friend.swift
//  VK client
//
//  Created by macbookpro on 28.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var friendID = 0
    @objc dynamic var profilePicUrl = ""
    
    override class func primaryKey() -> String? {
        return "friendID"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.profilePicUrl = json["photo_100"].stringValue
        self.friendID = json["id"].intValue
    }
}

