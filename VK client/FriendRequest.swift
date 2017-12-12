//
//  FriendRequest.swift
//  VK client
//
//  Created by macbookpro on 18.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FriendRequest: Object {
    @objc dynamic var friendID = 0
    
    override class func primaryKey() -> String? {
        return "friendID"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.friendID = json.intValue
    }
}
