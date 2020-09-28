//
//  PopUpBookshelfTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/24/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PopUpBookshelfTableViewController: UITableViewController {
    
    var bookISBN: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBookshelves()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = UserController.shared.currentUser else {return 0}
        return user.bookshelves.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = UserController.shared.currentUser else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfCell", for: indexPath)
        let bookshelf = user.bookshelves[indexPath.row]
        cell.textLabel?.text = bookshelf.title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = UserController.shared.currentUser else {return}
        guard let isbn = bookISBN else {return}
        let pickedBookshelf = user.bookshelves[indexPath.row]
        pickedBookshelf.books.append(isbn)
        BookshelfController.shared.updateBookshelf(bookshelf: pickedBookshelf, title: pickedBookshelf.title, color: pickedBookshelf.color) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.dismiss(animated: true)
                case .failure(_):
                    print("we could not update the bookshelf")
                }
            }
        }
    }
       
    //Mark: Helpers
    func fetchBookshelves() {
        guard let user = UserController.shared.currentUser else {return}
        BookshelfController.shared.fetchAllBookshelves { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookshelves):
                    user.bookshelves = bookshelves
                    self.tableView.reloadData()
                case .failure(_):
                    print("could not fetch user's bookshelves")
                }
            }
        }
    }
}
