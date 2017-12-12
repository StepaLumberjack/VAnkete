//
//  FriendsListViewController.swift
//  VK client
//
//  Created by macbookpro on 21.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class FriendsListViewController: UITableViewController {
    
    let vkFriendsService = VKFriendsService()
    var friends: Results<Friend>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        vkFriendsService.loadFriendsData()
        self.pairTableAndRealm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListViewCell", for: indexPath) as! FriendsListViewCell
        
        let friend = friends![indexPath.row]
        
        cell.friendName.text = friend.firstName + " " + friend.lastName
//        cell.ava.setImageFromUrl(stringImageUrl: friend.profilePicUrl)
        cell.id = friend.friendID
        
        let getCacheImage = GetCacheImage(url: friend.profilePicUrl)
        let setImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        OperationQueue.main.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsToPhotos" {
            let cell = sender as! FriendsListViewCell
            let ctrl = segue.destination as! FriendPhotosViewController
            if let indexPath = tableView.indexPath(for: cell) {
                ctrl.friendIdentifier = friends![indexPath.row].friendID
            }
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm () else { return }
        friends = realm.objects(Friend.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
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
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
