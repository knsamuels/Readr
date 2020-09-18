//
//  BookclubListTableViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookclubListTableViewController: UITableViewController {
    
    //MARK: - Properties
    var bookclubs: [Bookclub] = []
    var user: User?
    
    //MARK: - Outlets
    @IBOutlet weak var createNewBookclubButton: UIBarButtonItem!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else {return}
        if user != UserController.shared.currentUser {
            createNewBookclubButton.isEnabled = false
        } else {
            createNewBookclubButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBookclubs()
        self.title = "Bookclubs"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
//        self.navigationController?.navigationBar.tintColor = .black
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookclubs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookclubCell", for: indexPath) as? BookclubTableViewCell else {return UITableViewCell()}
        let bookclub = bookclubs[indexPath.row]
        cell.bookclub = bookclub
        return cell
    }

    // Mark: Helpers:
    func fetchBookclubs() {
        guard let user = user else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookclubs):
                    self.bookclubs = bookclubs
                    self.tableView.reloadData()
                case .failure(_):
                    print("Could not fetch user's bookclubs")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "bookclubListToVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclubs[indexPath.row]
            destination.bookclub = bookclubToSend
        }
    }
}
