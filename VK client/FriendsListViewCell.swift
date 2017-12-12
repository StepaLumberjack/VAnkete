//
//  FriendsListViewCell.swift
//  VK client
//
//  Created by macbookpro on 21.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit

class FriendsListViewCell: UITableViewCell {
    @IBOutlet weak var ava: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    var id: Int = 0

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
