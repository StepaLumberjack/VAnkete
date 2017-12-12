//
//  Group.swift
//  VK client
//
//  Created by macbookpro on 24.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//
import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var groupName = ""
    @objc dynamic var groupID = 0
    @objc dynamic var groupPicUrl = ""
    @objc dynamic var membersCount = 0
    
    override class func primaryKey() -> String? {
        return "groupID"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.groupName = json["name"].stringValue
        self.membersCount = json["members_count"].intValue
        self.groupPicUrl = json["photo_100"].stringValue
        self.groupID = json["id"].intValue
    }
}
