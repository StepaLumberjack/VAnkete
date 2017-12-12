//
//  Parser.swift
//  VK client
//
//  Created by macbookpro on 25.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonParser {
    func parse(_ json: JSON) -> [AnyObject]
}
