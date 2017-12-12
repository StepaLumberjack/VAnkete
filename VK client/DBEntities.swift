//
//  DBEntities.swift
//  VK client
//
//  Created by macbookpro on 06.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation

struct AuthenticatedUser {
    let id: String
    let enteredGroups: [EnteredGroups]
    
    var toAnyObject: Any {
        return [
            "id": id,
            "enteredGroups": enteredGroups.reduce([Int: Any](), { (prevResult, enteredGroups) in
                var prevResult = prevResult
                prevResult[enteredGroups.groupId] = enteredGroups.toAnyObject
                return prevResult
            })
                //{ $0.toAnyObject }
        ]
    }
}

struct EnteredGroups {
    let groupId: Int
    
    var toAnyObject: Any {
        return [
            "groupId": groupId
        ]
    }
}
