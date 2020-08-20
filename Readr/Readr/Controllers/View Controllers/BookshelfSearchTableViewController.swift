//
//  BookshelfSearchTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var bookshelf: Bookshelf?
    var bookshelfBooks: [Book] = []
    var resultsArray: [SearchableRecord] = []
    var isSearching = false
    var dataSource: [SearchableRecord] {
        return isSearching ? resultsArray : bookshelfBooks
    }
    
    // Mark Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchBooks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.resultsArray = self.bookshelfBooks
            self.tableView.reloadData()
        }
    }
    
    //Mark - Helper function
    func fetchBooks() {
        guard let bookshelf = bookshelf else {return}
        for i in bookshelf.books {
            BookController.fetchOneBookWith(ISBN: i) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let book):
                        self.bookshelfBooks.append(book)
                    case .failure(_):
                        print("we could not get the books from bookshelf")
                    }
                }
            }
        }
    }
    
    //Mark - Actions
    
    @IBAction func removeBookshelfButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfSearchCell", for: indexPath) as? BookshelfSearchTableViewCell else { return UITableViewCell() }
        let book = dataSource[indexPath.row] as? Book
        cell.book = book
        
        // Configure the cell...
        
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
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfSearchToBookshelfDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookshelfDetailViewController else {return}
            let bookToSend = bookshelfBooks[indexPath.row]
            destination.book = bookToSend
        }
     }
}

extension BookshelfSearchTableViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            resultsArray = bookshelfBooks.filter { $0.matches(searchTerm: searchText) }
            tableView.reloadData()
        } else {
            resultsArray = bookshelfBooks
            tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked( searchBar: UISearchBar) {

        resultsArray = bookshelfBooks
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        isSearching = false
    }

    func searchBarTextDidBeginEditing( searchBar: UISearchBar) {

        isSearching = true
    }

    func searchBarTextDidEndEditing( searchBar: UISearchBar) {

        searchBar.text = ""
        isSearching = false
    }

}
