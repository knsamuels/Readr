//
//  PopUpBookSearchTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/25/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PopUpBookSearchTableViewCell: UITableViewCell {
 
    var book: Book?  {
           didSet {
               updateViews()
           }
    }
    
    //Mark: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRatingLabel: UILabel!

    //MARK: - Helper
        func updateViews() {
            guard let book = book else {return}
            bookImageView.image = book.coverImage
            bookTitleLabel.text = book.title
            bookAuthorLabel.text = book.authors?.first
            bookRatingLabel.text = "Rating: \(String(book.averageRating ?? 0))"
        }

    
}

