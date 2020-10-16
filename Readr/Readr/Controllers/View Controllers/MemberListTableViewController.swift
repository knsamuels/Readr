//
//  MemberListTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class MemberListTableViewController: UITableViewController {
    
    
    var bookclub: Bookclub?
    var bookclubMembers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Members"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookclubMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? MemberTableViewCell else {return UITableViewCell()}
        guard let bookclub = bookclub else {return UITableViewCell()}
        guard let currentUser = UserController.shared.currentUser else {return UITableViewCell()}
        if bookclub.admin != currentUser.appleUserRef {
            cell.optionButton.isHidden = true
            cell.dotsStackView.isHidden = true
        } else {
            cell.optionButton.isHidden = false
            cell.dotsStackView.isHidden = false
        }
        let member = bookclubMembers[indexPath.row]
        cell.member = member
        //        cell.bookclub = bookclub
        return cell
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    //MARK: - Helper Functions
    func fetchUsers() {
        guard let bookclub = bookclub else {return}
        
        //        BookclubController.shared.fetchMembers(ofBookclub: bookclub) { (result) in
        //            switch result {
        //            case .success(let members):
        //                self.bookclubMembers = members
        //                self.tableView.reloadData()
        //            case .failure(_):
        //                print("FAILED!!")
        //            }
        //        }
        
        for reference in bookclub.members {
            UserController.shared.fetchUser(withReference: reference) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let member):
                        self.bookclubMembers.append(member)
                        self.tableView.reloadData()
                    case .failure(_):
                        print("Could not fetch member")
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memberListToUser" {
            guard let destination = segue.destination as?
                UserDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let userToSend = bookclubMembers[indexPath.row]
            destination.user = userToSend
        }
    }
}
