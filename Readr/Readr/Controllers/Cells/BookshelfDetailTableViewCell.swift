//
//  BookshelfSearchTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol BookshelfCellDelegate: AnyObject {
    func presentAlertController(user: User, isbn: String, bookshelf: Bookshelf, cell: BookshelfDetailTableViewCell)
}

class BookshelfDetailTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRatingLabel: UILabel!
    
    //MARK: - Properties
    var book: Book? {
        didSet{
            updateViews()
        }
    }
    var bookshelf: Bookshelf?
    weak var bookshelfDelegate: BookshelfCellDelegate?
    
    //MARK: - Actions
    @IBAction func removeBookButtonTapped(_ sender: UIButton) {
        guard let user = UserController.shared.currentUser else {return}
        guard let industryIdentifiers = book?.industryIdentifiers else {return}
        var isbn = ""
        for industryIdentifier in industryIdentifiers {
            if industryIdentifier.type == "ISBN_13" {
                isbn = industryIdentifier.identifier
            }
        }
        if isbn == "" {
            isbn = industryIdentifiers.first?.identifier ?? ""
        }
        guard let bookshelf = bookshelf else {return}
        bookshelfDelegate?.presentAlertController(user: user, isbn: isbn, bookshelf: bookshelf, cell: self)
    }
    
    //MARK: - Helper functions
    func updateViews() {
        guard let book = book else {return}
        let rating = " \(String(book.averageRating ?? 0))"
        bookImageView.image = book.coverImage
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.authors?.first ?? "no author"
        bookRatingLabel.text = rating
    }
    
} //End of class
