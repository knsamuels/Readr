//
//  PastReadsTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/24/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PastReadsTableViewCell: UITableViewCell {
   
    // MARK: - Outlets
    @IBOutlet weak var pastReadsTitleLabel: UILabel!
    @IBOutlet weak var pastReadsImage: UIImageView!
    @IBOutlet weak var pastReadsAuthorLabel: UILabel!
    @IBOutlet weak var pastReadsRatingLabel: UILabel!
    
    //Mark: Properties
       var book: Book?{
           didSet {
               updateViews()
           }
       }
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let book = book else {return}
        pastReadsImage.image = book.coverImage
        pastReadsTitleLabel.text = book.title
        pastReadsAuthorLabel.text = book.authors?.first
        pastReadsRatingLabel.text = "\(book.averageRating ?? 0.0)"
    }
}
