//
//  GroupsViewController.swift
//  VK client
//
//  Created by macbookpro on 24.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsViewController: UITableViewController {
    
    let vkGroupsService = VKGroupsService()
    var groups: Results<Group>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkGroupsService.loadGroupsData()
        pairTableAndRealm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsViewCell", for: indexPath) as! GroupsViewCell
        
        let group = groups![indexPath.row]

        cell.groupName.text = group.groupName
//        cell.ava.setImageFromUrl(stringImageUrl: group.groupPicUrl)
        
        let getCacheImage = GetCacheImage(url: group.groupPicUrl)
        let setImageToRow = SetGroupimageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
//        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        return cell
        
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm () else { return }
        groups = realm.objects(Group.self)
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    @IBAction func unwindToGroupsVC(segue: UIStoryboardSegue) {
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = groups?[indexPath.row].groupID else { return }
            
            vkGroupsService.leaveFromGroup(groupID: id) {}
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
