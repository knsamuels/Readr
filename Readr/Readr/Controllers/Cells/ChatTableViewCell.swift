//
//  ChatTableViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 9/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol ChatSpinnerDelegate: AnyObject {
    func stopSpinning()
}

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
    var recentMessage: Message?
    weak var chatSpinnerDelegate: ChatSpinnerDelegate?
    
    //MARK: - Helper Methods
    func fetchMessage() {
        guard let bookclub = bookclub else {return}
        MessageController.shared.fetchMessages(for: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self.clubMessages = messages
                    self.recentMessage = messages.last
                    self.updateViews()
                case .failure(_):
                    print("Unable to fetch messages for this bookclub.")
                }
            }
        }
    }
    
    func updateViews() {
        guard let bookclub = bookclub else {return}
        if let image = bookclub.profilePicture {
            bookclubImageView.image = image
        } else {
            bookclubImageView.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        bookclubTitleLabel.text = bookclub.name
        if clubMessages.count > 0 {
            guard let recentMessage = recentMessage else {return}
            lastmessageLabel.text = recentMessage.text
        } else {
            lastmessageLabel.text = " "
        }
        bookclubImageView.layer.cornerRadius = bookclubImageView.frame.width / 2
        bookclubImageView.clipsToBounds = true
        chatSpinnerDelegate?.stopSpinning()
    }
} //End of class
