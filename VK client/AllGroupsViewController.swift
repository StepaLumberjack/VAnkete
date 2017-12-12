//
//  AllGroupsViewController.swift
//  VK client
//
//  Created by macbookpro on 24.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class AllGroupsViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!

    //var isSearching = false
    
    let vkGroupsService = VKGroupsService()
    var filteredGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
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
        return filteredGroups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsViewCell", for: indexPath) as! AllGroupsViewCell
        
        cell.groupName.text = filteredGroups[indexPath.row].groupName
        cell.ava.setImageFromUrl(stringImageUrl: filteredGroups[indexPath.row].groupPicUrl)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vkGroupsService.joinToGroup(groupID: filteredGroups[indexPath.row].groupID) { [weak self] in
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
            let enteredGroup = EnteredGroups(groupId: (self?.filteredGroups[indexPath.row].groupID)!)
            let dbLink = Database.database().reference()
            dbLink.child("Authenticated users/\(globalID)/enteredGroups").updateChildValues(["\(enteredGroup.groupId)": enteredGroup.toAnyObject])
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == "" || searchBar.text == nil {
//            isSearching = false
//            view.endEditing(true)
//            tableView.reloadData()
//        } else {
//            isSearching = true
//            self.vkGroupsService.searchGroups(keyWord: searchBar.text!.lowercased()) { [weak self]
//                filteredGroups in
//                self?.filteredGroups = filteredGroups
//                self?.tableView.reloadData()
//            }
//        }
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let text = searchBar.text,
            !text.isEmpty else {
                
                tableView.reloadData()
                return
        }
        searchGroups(request: text)
        tableView.reloadData()
    }
    
    func searchGroups(request: String) {
        vkGroupsService.searchGroups(keyWord: request) { [weak self] filteredGroups  in
            self?.filteredGroups = filteredGroups
            self?.tableView.reloadData()
        }
    }


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
