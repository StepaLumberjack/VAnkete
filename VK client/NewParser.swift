//
//  NewParser.swift
//  VK client
//
//  Created by macbookpro on 25.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import SwiftyJSON

extension ParserFactory {
    struct News: JsonParser {
        
        static let deepType = [
            "post": nil,
            "wall_photo": "photos",
            "photo": "photos",
            "photo_tag": "profiles",
            "friend": "friends",
            "note": "profiles",
            "audio": "audio",
            "video": "video"
        ]
        
        let jsonToNew = { (json: JSON, groups: [Group], friends: [Friend]) -> New in
            var new = New()
            let type = json["type"].stringValue
            
            new.id = json["post_id"].intValue
            new.sourceId = json["source_id"].intValue
            
            var json = json
            
            if let deepTypeOptional = deepType[type], let type = deepTypeOptional  {
                json = json[type]["items"][0]
            }
            
            
            new.newsText = json["text"].stringValue
            if json["attachments"][0] == JSON.null {
                new.newsImageUrl = nil
            }
            else if json["attachments"][0]["type"] == "video" {
                new.newsImageUrl = json["attachments"][0]["video"]["photo_130"].stringValue
            }
            else if json["attachments"][0]["type"] == "photo" {
                new.newsImageUrl = json["attachments"][0]["photo"]["photo_130"].stringValue
            }
            else {
                new.newsImageUrl = nil
            }
            
            if new.sourceId > 0 {
                new.friend = friends.filter { $0.friendID == new.sourceId }.first
            } else {
                new.group = groups.filter { $0.groupID == abs(new.sourceId) }.first
            }
            
            return new
        }
        
        func parse(_ json: JSON) -> [AnyObject] {
            let groups = json["response"]["groups"].map { Group(json: $0.1) }
            let friends = json["response"]["profiles"].map { Friend(json: $0.1) }
            return json["response"]["items"].map { jsonToNew($0.1, groups, friends) }
        }
        
    }
}
