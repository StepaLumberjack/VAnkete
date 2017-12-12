//
//  VKGroupsService.swift
//  VK client
//
//  Created by macbookpro on 30.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class VKGroupsService {
    
    let sessionManager: SessionManager = sessionManagerG
    
//    func getUsersGroups(completion: @escaping([Group]) -> Void) {
//        
//        let parameters: Parameters = [
//            "access_token": "\(globalToken)",
//            "v": "5.68",
//            "extended": "1",
//            "fields": "members_count"
//        ]
//        
//        sessionManager.request("https://api.vk.com/method/groups.get", parameters: parameters).responseJSON { response in
//            
//            let responseVK = response.value as! [String: Any]
//            let enterResponse = responseVK["response"] as! [String:  Any]
//            let enterItems = enterResponse["items"] as! [[String: Any]]
//            let groups = enterItems.map() { Group(json: $0) }
//            completion(groups)
//        }
//    }
    
    func searchGroups(keyWord: String, completion: @escaping ([Group]) -> Void) {
        var parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68",
            "count": 15,
            "q": "\(keyWord)"
        ]
        
        sessionManager.request("https://api.vk.com/method/groups.search", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let groupsID = json?["response"]["items"].array?.flatMap {String(describing: $0["id"].intValue) }.joined(separator: ",")
            
            parameters.removeAll()
            parameters = [
                "access_token": "\(globalToken)",
                "v": "5.68",
                "group_ids": groupsID,
                "fields": "members_count"
            ]
            Alamofire.request("https://api.vk.com/method/groups.getById", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
                
                guard let data = response.value else { return }
                let json = try? JSON(data: data)
                let filteredGroups = json?["response"].array?.flatMap() { Group(json: $0) } ?? []
                DispatchQueue.main.async {
                    completion(filteredGroups)
                }
            }
        }
    }
    
    func joinToGroup (groupID: Int, completion: @escaping () -> () ) {
        let parameters: Parameters = [
            "group_id": groupID,
            "access_token": "\(globalToken)",
            "v": "5.68"
        ]
        sessionManager.request("https://api.vk.com/method/groups.join", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) {response in
            completion()
        }
    }
    
    func leaveFromGroup (groupID: Int, completion: @escaping () -> () ) {
        let parameters: Parameters = [
            "group_id": groupID,
            "access_token": "\(globalToken)",
            "v": "5.68"
        ]
        sessionManager.request("https://api.vk.com/method/groups.leave", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) {response in
            completion()
        }
    }
    
    func saveGroupsData (_ groups: [Group]) {
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(Group.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func loadGroupsData() {
        let parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68",
            "extended": "1",
            "fields": "members_count"
        ]
        
        sessionManager.request("https://api.vk.com/method/groups.get", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let groups = json?["response"]["items"].array?.flatMap() { Group(json: $0) } ?? []
            self.saveGroupsData(groups)
        }
    }
}
