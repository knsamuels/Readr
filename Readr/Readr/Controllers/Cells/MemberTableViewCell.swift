//
//  MemberTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/16/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol BlockMemberDelegate: AnyObject {
    func presentBlockAlert(member: User)
}

class MemberTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var dotsStackView: UIStackView!
    
    //MARK: - Properties
    var member: User? {
        didSet{
            updateViews()
        }
    }
    var bookclub: Bookclub?
    weak var blockDelegate: BlockMemberDelegate?
    
    //MARK: _ Actions
    @IBAction func optionButtonTapped(_ sender: Any) {
        guard let member = member else {return}
        blockDelegate?.presentBlockAlert(member: member)
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        guard let member = member else {return}
        memberName.text = "\(member.firstName) \(member.lastName)"
        if let image = member.profilePhoto {
            memberImage.image = image
        } else {
            memberImage.image = member.profilePhoto ?? UIImage(named: "ReadenLogoWhiteSpace")
        }
        memberImage.layer.cornerRadius = memberImage.frame.height / 2
        memberImage.clipsToBounds = true
    }
} //End of class
