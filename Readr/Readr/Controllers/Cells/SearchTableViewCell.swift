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
            updateViews()
        }
    }
    var bookclub: Bookclub? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let user = user {
            personOrClubImage.image = user.profilePhoto
            personOrClubLabel.text = "\(user.firstName) \(user.lastName)"
        } else if let bookclub = bookclub {
            personOrClubLabel.text = bookclub.name
            personOrClubImage.image = bookclub.profilePicture
        }
    }

   

}
