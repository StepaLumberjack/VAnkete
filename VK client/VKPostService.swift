//
//  VKPostService.swift
//  VK client
//
//  Created by macbookpro on 16.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct VKPostService {
    let sessionManager = sessionManagerG
    
    func postMessage(text: String, lat: Double, long: Double) {
        let parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68",
            "message": text,
            "lat": lat,
            "long": long
        ]
        
        sessionManager.request("https://api.vk.com/method/wall.post", parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { response in
            print(response.value ?? response.error ?? "fucked up")
        }
    }
}
