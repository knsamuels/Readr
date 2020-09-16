//
//  MemberTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/16/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    //MARK: - Properties
    var member: User? {
        didSet{
            updateViews()
        }
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        guard let member = member else {return}
        memberName.text = "\(member.firstName) \(member.lastName)"
        if let image = member.profilePhoto {
            memberImage.image = image
        } else {
            memberImage.image = member.profilePhoto ?? UIImage(named: "ReadenLogo")
        }
    }
}
