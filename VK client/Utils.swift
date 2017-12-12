//
//  Utils.swift
//  VK client
//
//  Created by macbookpro on 18.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import UserNotifications

let fetchRequestsGroup = DispatchGroup()
var timer: DispatchSourceTimer?
var lastUpdate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "Last Update") as? Date
    }
    set {
        UserDefaults.standard.setValue(Date(), forKey: "Last Update")
    }
}

func requestNotification(_ badgeNumber: Int) {
    
    removeNotifications(withIdentifiers: ["friend request"])
    
    let content = UNMutableNotificationContent()
    content.badge = badgeNumber as NSNumber
    content.title = "WARNING! VK Friend Request"
    content.body = "You have \(Int(content.badge!)) friend requests"
    content.sound = UNNotificationSound.default()
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: "friend request", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { (error) in
        print("ошибка с нотификациями \(error)")
    }
}

func removeNotifications(withIdentifiers identifiers: [String]) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
}

