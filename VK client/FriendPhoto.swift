//
//  FriendPhoto.swift
//  VK client
//
//  Created by macbookpro on 01.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FriendPhoto {
    var picUrl = ""
    var ownerID = 0
    
    init(json: JSON, ownerID: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
        self.picUrl = json["photo_130"].stringValue
        self.ownerID = ownerID
        }
    }
}
