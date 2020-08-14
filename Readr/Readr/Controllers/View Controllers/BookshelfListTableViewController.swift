//
//  BookshelfListTableViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfListTableViewController: UITableViewController {
    
    var userBookshelves: [Bookshelf] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBookshelf()
        fetchAllUsersFavorites()
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        presentBookshelfAlert(bookshelf: nil)
    }
    //Mark: - Helper Functions
    
    func createBookshelf() {
        BookshelfController.shared.createBookshelf(title: "Harry Potter Rocks") { (result) in
            switch result {
            case .success(_):
                print("We created a bookshelf")
            case .failure(_):
                print("We could not create a bookshelf")
            }
        }
    }
    
    
    func fetchAllUsersFavorites() {
        BookshelfController.shared.fetchAllBookshelfs { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookshelves):
                    self.userBookshelves = bookshelves
                    self.tableView.reloadData()
                case .failure(_):
                    print("we could not fetch the users bookshelves")
                }
            }
        }
    }
    
    func presentBookshelfAlert(bookshelf: Bookshelf?) {
        let alertController = UIAlertController(title: "Create Bookshelf", message: "", preferredStyle: .actionSheet)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Name of bookshelf..."
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addBookclubAction = UIAlertAction(title: "Create", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            if let bookshelf =  bookshelf {
                BookshelfController.shared.createBookshelf(title: bookshelf.title) { (result) in
                    switch result {
                    case .success(let bookshelf):
                        self.userBookshelves.append(bookshelf)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error.errorDescription)
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addBookclubAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBookshelves.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfCell", for: indexPath)
        let bookshelf = userBookshelves[indexPath.row]
        cell.textLabel?.text = bookshelf.title
        cell.detailTextLabel?.text = "\(bookshelf.books.count)"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
