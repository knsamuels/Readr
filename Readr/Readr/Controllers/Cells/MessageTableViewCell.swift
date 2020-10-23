//
//  MessageTableViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //MARK: - Properties
    var message: Message? {
        didSet {
            updateViews()
        }
    }
  
    //MARK: - Helper Methods
    func updateViews() {
        guard let message = message else {return}
        messageLabel.text = message.text
        usernameLabel.text = message.user
        if message.user == UserController.shared.currentUser?.username {
            messageLabel.textAlignment = .right
            usernameLabel.textAlignment = .right
            usernameLabel.textColor = .blue
        } else {
            messageLabel.textAlignment = .left
            usernameLabel.textAlignment = .left
            usernameLabel.textColor = .red
        }
    }
} //End of class
