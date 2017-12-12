//
//  VKFriendsService.swift
//  VK client
//
//  Created by macbookpro on 30.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class VKFriendsService {
    
    let sessionManager = sessionManagerG
    
//    func getFriends(completion: @escaping([Friend]) -> Void) {
//        let parameters: Parameters = [
//            "access_token": "\(globalToken)",
//            "v": "5.68",
//            "order": "hints",
//            "fields": "photo_100",
//            "name_case": "nom"
//        ]
//        
//        sessionManager.request("https://api.vk.com/method/friends.get", parameters: parameters).responseJSON { response in
//            
//            let responseVK = response.value as! [String: Any]
//            let enterResponse = responseVK["response"] as! [String:  Any]
//            let enterItems = enterResponse["items"] as! [[String: Any]]
//            let friends = enterItems.map() { Friend(json: $0) }
//            completion(friends)
//        }
//    }
    
    func getPhotos(ownerID: Int, completion: @escaping([FriendPhoto]) -> Void) {
        let parameters: Parameters  = [
            "owner_id": ownerID,
            "album_id": "profile",
            "rev": 1,
            "access_token": "\(globalToken)",
            "v": "5.68",
        ]
        
        sessionManager.request("https://api.vk.com/method/photos.get", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let friendPhotos = json?["response"]["items"].array?.flatMap() { FriendPhoto(json: $0, ownerID: ownerID) } ?? []
            DispatchQueue.main.async {
                completion(friendPhotos)
            }
        }
    }
    
    func saveFriendsData(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            let oldFriends = realm.objects(Friend.self)
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    func saveRequestsData(_ requests: [FriendRequest]) {
        do {
            let realm = try Realm()
            let oldRequests = realm.objects(FriendRequest.self)
            realm.beginWrite()
            realm.delete(oldRequests)
            realm.add(requests, update: true)
            try realm.commitWrite()
            
            print(realm.configuration.fileURL)
            if timer != nil {
                fetchRequestsGroup.leave()
            }
        } catch {
            print(error)
        }
    }
    
    func loadFriendsData() {
        let parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68",
            "order": "hints",
            "fields": "photo_100",
            "name_case": "nom"
        ]
        
        sessionManager.request("https://api.vk.com/method/friends.get", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let friends = json?["response"]["items"].array?.flatMap() { Friend(json: $0) } ?? []
            self.saveFriendsData(friends)
        }
    }
    func loadRequestsData() {
        let parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68"
        ]
        sessionManager.request("https://api.vk.com/method/friends.getRequests", parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let friendRequests = json?["response"]["items"].array?.flatMap() { FriendRequest(json: $0) } ?? []
            self.saveRequestsData(friendRequests)
            //print(response.value ?? response.error ?? "fucked up")
        }
    }
}
