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
        self.title = "Chat"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        
        let bookclub = bookclubsArray[indexPath.row]
        
        cell.bookclub = bookclub
        
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
