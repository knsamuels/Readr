//
//  BookshelfSearchTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfDetailTableViewController: UITableViewController, UISearchBarDelegate {
    
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
        bookshelfBooks = []
        for i in bookshelf.books {
            BookController.fetchOneBookWith(ISBN: i) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let book):
                        self.bookshelfBooks.append(book)
                        self.tableView.reloadData()
                        print(bookshelf.books.count)
                        print(self.bookshelfBooks.count)
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
//        return dataSource.count
        return bookshelfBooks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfSearchCell", for: indexPath) as? BookshelfDetailTableViewCell else { return UITableViewCell() }
        guard let bookshelf = bookshelf else {return UITableViewCell()}
//        let book = dataSource[indexPath.row] as? Book
        let book = bookshelfBooks[indexPath.row] 
        cell.book = book
        cell.bookshelfDelegate = self
        cell.bookshelf = bookshelf
       
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
        if segue.identifier == "BookshelfSearchToBookDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = bookshelfBooks[indexPath.row]
            destination.book = bookToSend as? Book
        }
     }
}

extension BookshelfDetailTableViewController {
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
extension BookshelfDetailTableViewController: BookshelfCellDelegate {
    func presentAlertController(user: User, isbn: String, bookshelf: Bookshelf, cell: BookshelfDetailTableViewCell) {
        let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let removeAction = UIAlertAction(title: "Remove from Shelf", style: .default) { (_) in
            guard let index = bookshelf.books.firstIndex(of: isbn) else {return}
            bookshelf.books.remove(at: index)
            self.fetchBooks()
//            guard let filteredIndex = self.bookshelfBooks.firstIndex(of: <#T##Book#>)
//            self.bookshelfBooks.remove(at: index)
            BookshelfController.shared.updateBookshelf(bookshelf: bookshelf) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.tableView.reloadData()
                    case .failure(_):
                        print("failed to update bookshelf")
                    }
                }
            }

        }
        let addAction = UIAlertAction(title: "Add to Another Shelf", style: .default) { (_) in
            guard let popUpTBVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "popUpBookshelfTBVC") as? PopUpBookshelfTableViewController else {return}
            popUpTBVC.modalPresentationStyle = .automatic
            popUpTBVC.bookISBN = isbn
            self.present(popUpTBVC, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(removeAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: true)
    }
}
