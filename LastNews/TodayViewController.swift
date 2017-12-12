//
//  TodayViewController.swift
//  LastNews
//
//  Created by macbookpro on 02.12.2017.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var TextOfANew: UILabel!
    @IBOutlet weak var PicOfANew: UIImageView!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    lazy var url: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: "d44575625a3c5e895297748d6356bd7810321cd2a4fd8fef692c7d01fed4fa4689037d077ba2fe1f0d28c"),
            URLQueryItem(name: "v", value: "5.68"),
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "1")
        ]
        return components.url
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = url else {
            assertionFailure()
            return
        }
        print(url)
        session.dataTask(with: url) { data, response, error in
            print(data, error)
            guard let data = data else {
                assertionFailure()
                return
            }
           guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
                return
            }
            let array = json as! [String: Any]
            let response = array["response"] as! [String: Any]
            let items = response["items"] as! [[String: Any]]
            var text = items[0]["text"] as? String
            if text == "" {
                text = "no text new"
            }
            self.TextOfANew.text = text
            let sourceID = items[0]["source_id"] as! Int
            if sourceID > 0 {
                let profiles = response["profiles"] as! [[String: Any]]
                let picture = profiles[0]["photo_100"] as? String ?? "https://www.google.ru/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwi815XQ9evXAhUED5oKHXxRC50QjRwIBw&url=https%3A%2F%2Ftwitter.com%2Femojifinger&psig=AOvVaw3Xp8ED6p_F223NQFNg5Q5T&ust=1512324415983706"
                self.PicOfANew.setImageFromUrl(stringImageUrl: picture)
            } else {
                let groups = response["groups"] as! [[String: Any]]
                let picture = groups[0]["photo_100"] as? String ?? "https://www.google.ru/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwi815XQ9evXAhUED5oKHXxRC50QjRwIBw&url=https%3A%2F%2Ftwitter.com%2Femojifinger&psig=AOvVaw3Xp8ED6p_F223NQFNg5Q5T&ust=1512324415983706"
                self.PicOfANew.setImageFromUrl(stringImageUrl: picture)
            }
        }.resume()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

extension UIImageView {
    
    func setImageFromUrl (stringImageUrl url: String) {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
