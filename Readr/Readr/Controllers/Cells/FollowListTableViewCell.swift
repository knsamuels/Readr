//
//  FollowListTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 10/3/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FollowListTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var followImage: UIImageView!
    @IBOutlet weak var followNameLabel: UILabel!
    
    //MARK: - Properties
    var member: User? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        guard let member = member else {return}
        followNameLabel.text = "\(member.firstName) \(member.lastName)"
        if let image = member.profilePhoto {
            followImage.image = image
        } else {
           followImage.image = member.profilePhoto ?? UIImage(named: "ReadenLogo")
        }
        followImage.layer.cornerRadius = followImage.frame.height / 2
        followImage.clipsToBounds = true
    }
} //End of class
