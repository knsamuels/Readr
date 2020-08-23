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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAllUsersFavorites()
    }
    
    // Mark: Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentBookshelfAlert(bookshelf: nil)
    }
    //Mark: - Helper Functions
    
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
        let alertController = UIAlertController(title: "Create Bookshelf", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Name of bookshelf..."
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addBookclubAction = UIAlertAction(title: "Create", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            
            BookshelfController.shared.createBookshelf(title: text) { (result) in
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
        
        alertController.addAction(cancelAction)
        alertController.addAction(addBookclubAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBookshelves.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfCell", for: indexPath) as? BookshelfCellTableViewCell else {return UITableViewCell()}
        let bookshelf = userBookshelves[indexPath.row]
        cell.bookshelf = bookshelf
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookshelfToDelete = userBookshelves[indexPath.row]
            guard let index = userBookshelves.firstIndex(of: bookshelfToDelete) else { return}
            
            BookshelfController.shared.deleteBookshelf(bookshelf: bookshelfToDelete) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.userBookshelves.remove(at: index)
                        self.tableView.reloadData()
                    case .failure(_):
                        print("no - error")
                    }
                }
            }
            
        } else if editingStyle == .insert {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfListToBookShelf" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookshelfDetailTableViewController else {return}
            let bookshelfToSend = userBookshelves[indexPath.row]
            destination.bookshelf = bookshelfToSend
        }
    }
}
