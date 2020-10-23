//
//  PopUpBooksSearchTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/25/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol PopUpBookSearchDelegate: class {
    func didSelectBook(book: Book)
}

class PopUpBooksSearchTableViewController: UITableViewController  {
    
    //MARK: - Properties
    weak var bookDelegate: PopUpBookSearchDelegate?
    var books: [Book] = []
    
    //MARK: - Outlets
    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSearchBar.delegate = self
        bookSearchBar.placeholder = "Search Book Title here..."
    }
    
    // MARK: - Helper functions
    func search() {
        guard let searchTerm = bookSearchBar.text else {return}
            BookController.fetchBooksWith(searchTerm: searchTerm) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let books):
                        self.books = books
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.errorDescription ?? "Unable to fetch books.")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? PopUpBookSearchTableViewCell else {return UITableViewCell()}
        let book = books[indexPath.row]
        cell.book = book
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        bookDelegate?.didSelectBook(book: book)
        dismiss(animated: true, completion: nil)
    }
}

extension PopUpBooksSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
