//
//  BookshelfSearchTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfDetailTableViewCell: UITableViewCell {
    
    var book: Book? {
        didSet{
            updateViews()
        }
    }

    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var bookRatingLabel: UILabel!
    
    
// Mark: Helper functions
    
    func updateViews() {
        guard let book = book else {return}
        let rating = "\(book.averageRating)"
        bookImageView.image = book.coverImage
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.authors?.first ?? "no author"
        bookRatingLabel.text = rating
    }
    
    //Mark: Actions
    
    @IBAction func removeBookButtonTapped(_ sender: UIButton) {
    }
    
}
