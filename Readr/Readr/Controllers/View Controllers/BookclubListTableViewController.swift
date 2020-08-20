//
//  BookclubListTableViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookclubListTableViewController: UITableViewController {

    
    var bookclubs: [Bookclub] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBookclubs()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return bookclubs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookclubCell", for: indexPath)
        let bookclub = bookclubs[indexPath.row]
        cell.textLabel?.text = bookclub.name
        return cell
    }

    // Mark: Helpers:
    
    func fetchBookclubs() {
        guard let user = UserController.shared.currentUser else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            switch result {
            case .success(let bookclubs):
                self.bookclubs = bookclubs
                self.tableView.reloadData()
            case .failure(_):
                print("Could not fetch user's bookclubs")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclubs[indexPath.row]
            destination.bookclub = bookclubToSend
        }
    }
}
