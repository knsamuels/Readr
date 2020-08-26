//
//  SearchTableViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //Mark: Outlets
    
    @IBOutlet weak var personOrClubImage: UIImageView!
    @IBOutlet weak var personOrClubLabel: UILabel!
    
    //Mark: Properties
    var user: User? {
        didSet {
            updateUserViews()
        }
    }
    var bookclub: Bookclub? {
        didSet {
            updateBookclubViews()
        }
    }
    
    func updateUserViews() {
        guard let user = user else {return}
        personOrClubImage.image = user.profilePhoto
        personOrClubLabel.text = "\(user.firstName) \(user.lastName)"
    }
    func updateBookclubViews() {
        guard let bookclub = bookclub else {return}
        personOrClubImage.image = bookclub.profilePicture
        personOrClubLabel.text = bookclub.name
    }

} //End of class
