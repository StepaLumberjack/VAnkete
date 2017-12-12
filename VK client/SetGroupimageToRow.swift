//
//  SetGroupimageToRow.swift
//  VK client
//
//  Created by macbookpro on 04.11.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import Foundation
import UIKit

class SetGroupimageToRow: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: GroupsViewCell?
    
    init(cell: GroupsViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.ava.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.ava.image = image
        }
    }
}
