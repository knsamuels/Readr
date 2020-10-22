//
//  BookclubTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/16/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookclubTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var bookclubImage: UIImageView!
    @IBOutlet weak var bookclubLabel: UILabel!
    
    //MARK: - Properties
    var bookclub: Bookclub? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let bookclub = bookclub else {return}
        if let image1 = bookclub.profilePicture {
            self.bookclubImage.image = image1
        } else {
            self.bookclubImage.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        bookclubImage.layer.cornerRadius = bookclubImage.frame.height / 2
        bookclubImage.clipsToBounds = true
        bookclubLabel.text = bookclub.name
    }
    
} //End of class
