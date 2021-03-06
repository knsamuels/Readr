//
//  SearchTableViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var personOrClubImage: UIImageView!
    @IBOutlet weak var personOrClubLabel: UILabel!
    
    //MARK: - Properties
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
    
    //MARK: - Helpers
    func updateUserViews() {
        guard let user = user else {return}
        personOrClubLabel.text = "\(user.firstName) \(user.lastName)"
        if let image = user.profilePhoto {
            personOrClubImage.image = image
        } else {
            personOrClubImage.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        personOrClubImage.layer.cornerRadius = personOrClubImage.frame.height / 2
        personOrClubImage.clipsToBounds = true
    }
    
    func updateBookclubViews() {
        guard let bookclub = bookclub else {return}
        personOrClubLabel.text = bookclub.name
        if let image = bookclub.profilePicture {
            personOrClubImage.image = image
        } else {
            personOrClubImage.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        personOrClubImage.layer.cornerRadius = personOrClubImage.frame.height / 2
        personOrClubImage.clipsToBounds = true
    }
} //End of class
