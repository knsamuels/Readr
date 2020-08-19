//
//  ChatTableViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    // MARK: - Properties
    var bookclubsArray: [Bookclub] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBookclubs()
        
    }
    
    // MARK: - Helper Methods
    func fetchBookclubs() {
        guard let user = UserController.shared.currentUser else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookclubs):
                    self.bookclubsArray = bookclubs
                    self.tableView.reloadData()
                case .failure(_):
                    print("Error fetching bookclubs.")
                }
            }
        }
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookclubsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        let bookclub = bookclubsArray[indexPath.row]
        
        cell.textLabel?.text = bookclub.name
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as? MessageViewController
            let bookclub = bookclubsArray[indexPath.row]
            destinationVC?.bookclub = bookclub
        }
     }
     
    
} //end class
