//
//  PopUpBookSearchTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/25/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PopUpBookSearchTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var book: Book?  {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRatingLabel: UILabel!
    
    //MARK: - Helpers
    func updateViews() {
        guard let book = book else {return}
        bookImageView.image = book.coverImage
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.authors?.first
        bookRatingLabel.text = " \(String(book.averageRating ?? 0))"
    }
    
} //End of class

