//
//  BookshelfSearchTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfSearchTableViewCell: UITableViewCell {
    
    var book: Book?

    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var bookRatingLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Actions:
    
    @IBAction func removeBookButtonTapped(_ sender: UIButton) {
    }
    
}
