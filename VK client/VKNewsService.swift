//
//  VKNewsService.swift
//  VK client
//
//  Created by macbookpro on 15.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
//import RealmSwift

struct VKNewsService {
    let sessionManager = sessionManagerG
    private let parser: JsonParser = ParserFactory().newsFeed()
    
    func getNews(completion: @escaping([New]) -> Void) {
        let parameters: Parameters = [
            "access_token": "\(globalToken)",
            "v": "5.68",
            "filters": "post",
            "count": 20
        ]
        
        sessionManager.request("https://api.vk.com/method/newsfeed.get", parameters: parameters).responseData(queue: .global(qos: .userInteractive)) { response in
            
            guard let data = response.value else { return }
            let json = try? JSON(data: data)
            let news = self.parser.parse(json!) as? [New] ?? []
            DispatchQueue.main.async {
                completion(news)
            }
            //print(response.value ?? response.error)
        }
    }
}
