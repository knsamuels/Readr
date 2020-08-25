//
//  PopUpBooksSearchTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/25/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PopUpBooksSearchTableViewController: UITableViewController  {

    var books: [Book] = []
    
    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSearchBar.delegate = self

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
        if let presenter = presentingViewController as? CreateBCViewController {
            presenter.currentlyReadingBook = book
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PopUpBooksSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
