//
//  BookshelfListTableViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundColorView: ReadenView!
    
    //MARK: - Properties
    var userBookshelves: [Bookshelf] = []
    var myString = ""
    var newColor = ""
    var newTitle = ""
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BOOKSHELF"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
        tableView.separatorColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAllUsersBookshelves()
    }
    
    // Mark: Actions
    @IBAction func unwindToShelfList(_ sender: UIStoryboardSegue) {
        //print(myString)
        BookshelfController.shared.createBookshelf(title: newTitle, color: newColor) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookshelf):
                    self.userBookshelves.append(bookshelf)
                    self.tableView.reloadData()
                    //self.dismiss(animated: true)
                    //self.customAlertDelegate?.updateBookshelfTableViewWith(bookshelf: bookshelf)
                case .failure(_):
                    print("Unable to create bookshelf.")
                }
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentCustomAlert()
    }
    
    //Mark: - Helper Functions
    func fetchAllUsersBookshelves() {
        BookshelfController.shared.fetchAllBookshelves { (result) in
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
    
    func presentCustomAlert() {
        guard let customAlert = UIStoryboard(name: "Alert", bundle: .main).instantiateViewController(withIdentifier: "AlertVC") as? PlaceholderViewController else {return}
        
        guard let AlertVC = UIStoryboard(name: "Alert", bundle: .main).instantiateViewController(withIdentifier: "CustomVC") as? AlertViewController else {return}
        AlertVC.customAlertDelegate = self
        
        present(customAlert, animated: true)
        //completion()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBookshelves.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfCell", for: indexPath) as? BookshelfListTableViewCell else {return UITableViewCell()}
        
        let bookshelf = userBookshelves[indexPath.row]
        cell.bookshelf = bookshelf
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookshelfToDelete = userBookshelves[indexPath.row]
            guard let index = userBookshelves.firstIndex(of: bookshelfToDelete) else { return}
            if bookshelfToDelete.title != "Favorites" {
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
} //End of class

extension BookshelfListTableViewController: CustomAlertBookshelfDelegate {
    func updateBookshelfTableViewWith(bookshelf: Bookshelf) {
        print("Delegate function activated")
        self.userBookshelves.append(bookshelf)
        self.tableView.reloadData()
    }
}

