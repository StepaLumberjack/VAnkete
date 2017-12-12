//
//  ParserFactory.swift
//  VK client
//
//  Created by macbookpro on 25.10.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation

struct ParserFactory {
    
    func newsFeed() -> JsonParser {
        return ParserFactory.News()
    }
}
