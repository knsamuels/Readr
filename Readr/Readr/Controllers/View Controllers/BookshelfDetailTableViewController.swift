//
//  BookshelfSearchTableViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfDetailTableViewController: UITableViewController {
    
    //MARK: - Properties
    var bookshelf: Bookshelf?
    var bookshelfBooks: [Book] = []
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Helper functions
    private func setUpViews() {
        tableView.separatorColor = .clear
        self.title = bookshelf?.title
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func fetchBooks() {
        guard let bookshelf = bookshelf else {return}
        bookshelfBooks = []
        for i in bookshelf.books {
            BookController.fetchOneBookWith(ISBN: i) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let book):
                        self.bookshelfBooks.append(book)
                        let sortedBooks = self.bookshelfBooks.sorted(by: { $0.title < $1.title })
                        self.bookshelfBooks = sortedBooks
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
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookshelfBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfSearchCell", for: indexPath) as? BookshelfDetailTableViewCell else { return UITableViewCell() }
        guard let bookshelf = bookshelf else {return UITableViewCell()}
        let book = bookshelfBooks[indexPath.row] 
        cell.book = book
        cell.bookshelfDelegate = self
        cell.bookshelf = bookshelf
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfSearchToBookDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = bookshelfBooks[indexPath.row]
            destination.book = bookToSend
        }
    }
} //End of class

extension BookshelfDetailTableViewController: BookshelfCellDelegate {
    func presentAlertController(user: User, isbn: String, bookshelf: Bookshelf, cell: BookshelfDetailTableViewCell) {
        let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let removeAction = UIAlertAction(title: "Remove from Shelf", style: .default) { (_) in
            guard let index = bookshelf.books.firstIndex(of: isbn) else {return}
            bookshelf.books.remove(at: index)
            self.fetchBooks()
            BookshelfController.shared.updateBookshelf(bookshelf: bookshelf, title: bookshelf.title, color: bookshelf.color) { (result) in
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
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(removeAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: true)
    }
} //End of extension
