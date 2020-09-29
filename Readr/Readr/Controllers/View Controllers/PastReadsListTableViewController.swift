//
//  PastReadsListTableViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/21/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PastReadsListTableViewController: UITableViewController {
    
    //    var pastReads: [String]?
    var books: [Book]?
    var bookclub: Bookclub?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Past Reads"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
                   self.navigationController?.navigationBar.tintColor = .black
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    // MARK: - Helpers
    
    //    func fetchBooks() {
    //        guard let pastReads = pastReads else {return}
    //        let group = DispatchGroup()
    //        for ISBN in pastReads {
    //            group.enter()
    //            BookController.fetchOneBookWith(ISBN: ISBN) { (result) in
    //                DispatchQueue.main.async {
    //                    switch result {
    //                    case .success(let book):
    //                        self.books.append(book)
    //                    case .failure(_):
    //                        print("we could not load pastreads")
    //                    }
    //                    group.leave()
    //                }
    //            }
    //        }
    //        group.notify(queue: .main) {
    //            self.tableView.reloadData()
    //        }
    //    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let books = books else {return 0}
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? PastReadsTableViewCell else {return UITableViewCell()}
        guard let books = books else {return UITableViewCell()}
        let book = books[indexPath.row]
        cell.book = book
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    public override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let bookclub = bookclub else {return UITableViewCell.EditingStyle.none}
        if UserController.shared.currentUser?.appleUserRef != bookclub.admin {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard var books = books else {return}
        guard let bookclub = bookclub else {return}
        var pastreads = bookclub.pastReads
        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
            let bookToDelete = books[indexPath.row]
            guard let index = books.firstIndex(of: bookToDelete) else {return}
            
            guard let industryIdentifiers = bookToDelete.industryIdentifiers else {return}
            var isbnToDelete = ""
            for industryIdentifier in industryIdentifiers {
                if industryIdentifier.type == "ISBN_13" {
                    isbnToDelete = industryIdentifier.identifier
                }
            }
            if isbnToDelete == "" {
                isbnToDelete = industryIdentifiers.first?.identifier ?? ""
            }
            guard let indexOfIsbn = pastreads.firstIndex(of: isbnToDelete) else {return}
            pastreads.remove(at: indexOfIsbn)
            bookclub.pastReads = pastreads
            BookclubController.shared.update(bookclub: bookclub) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.books?.remove(at: index)
                        self.tableView.reloadData()
                    case .failure(_):
                        print("Could not delete book from past reads")
                    }
                }
            }
        }
    }
    
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
        if segue.identifier == "pastReadsToBookDetail" {
            guard let books = books else {return}
            guard let destination = segue.destination as?
                BookDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let bookToSend = books[indexPath.row]
            destination.book = bookToSend
        }
    }
}


