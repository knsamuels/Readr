//
//  ChatTableViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 9/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var bookclubImageView: UIImageView!
    @IBOutlet weak var bookclubTitleLabel: UILabel!
    @IBOutlet weak var lastmessageLabel: UILabel!
    
    //MARK: - Properties
    var bookclub: Bookclub? {
        didSet {
            fetchMessage()
        }
    }
    var clubMessages: [Message] = []
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Helper Methods
    func fetchMessage() {
        guard let bookclub = bookclub else {return}
        MessageController.shared.fetchMessages(for: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self.clubMessages = messages
                    self.updateViews()
                case .failure(_):
                    print("Unable to fetch messages for this bookclub.")
                }
            }
        }
    }
    
    func updateViews() {
        guard let bookclub = bookclub else {return}
        bookclubImageView.image = bookclub.profilePicture
        bookclubTitleLabel.text = bookclub.name
        if clubMessages.count > 0 {
            lastmessageLabel.text = clubMessages[clubMessages.count - 1].text
        } else {
            lastmessageLabel.text = " "
        }
        
        
        bookclubImageView.layer.cornerRadius = bookclubImageView.frame.width / 2
        bookclubImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

} //End of class
