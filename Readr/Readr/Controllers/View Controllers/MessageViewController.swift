//
//  MessageViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bookclubImageView: UIImageView!
    @IBOutlet weak var bookclubTitleLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    // MARK: - Properties
    var bookclub: Bookclub?
    var messagesArray: [Message] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTextViews()
        fetchMessages()
        updateViews()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReloadEventsTable), name: Notification.Name(rawValue: "reloadEventsTable"), object: nil)
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveData(_:)), name: NSNotification.Name(rawValue: "ReceiveData"), object: nil)
    }
    
    // MARK: - Actions
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let text = messageTextView.text, !text.isEmpty else {return}
        guard let bookclub = bookclub else {return}
        
        MessageController.shared.saveMessage(text: text, image: nil, bookclub: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.messagesArray.append(message)
                    self.tableView.reloadData()
                case .failure(_):
                    print("Error saving message.")
                }
            }
        }
        messageTextView.text = ""
        messageTextView.resignFirstResponder()
    }
    
    
    // MARK: - Helper Methods
    
    func updateViews() {
        guard let bookclub = bookclub else {return}
        //self.title = bookclub.name
        if let image = bookclub.profilePicture {
            bookclubImageView.image = image
        } else {
            bookclubImageView.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        bookclubTitleLabel.text = bookclub.name
        memberCountLabel.text = "\(bookclub.members.count) people"
        
        bookclubImageView.layer.cornerRadius = bookclubImageView.frame.width / 2
        bookclubImageView.clipsToBounds = true
    }
    
    func fetchMessages() {
        guard let bookclub = bookclub else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            MessageController.shared.fetchMessages(for: bookclub) { (result) in
                DispatchQueue.main.async {
                    guard let strongSelf = self else {return}
                    switch result {
                    case .success(let messages):
                        strongSelf.messagesArray = messages
                        strongSelf.tableView.reloadData()
                        print("testing to see if we can fetch messages")
                        print(strongSelf.messagesArray.count)
                        if strongSelf.messagesArray.count > 0 {
                            let indexPath = IndexPath(row: strongSelf.messagesArray.count - 1, section: 0)
                            strongSelf.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            return
                        }
                    case .failure(_):
                        print("Error fetching messages")
                    }
                }
            }
        })
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.layer.cornerRadius = 15.0
        tableView.clipsToBounds = true
    }
    
    func setupTextViews() {
        messageTextView.delegate = self
        messageTextView.layer.cornerRadius = 15.0
        messageTextView.clipsToBounds = true
        
        if messageTextView.text.isEmpty {
            messageTextView.text = "Message..."
            messageTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func onReloadEventsTable() {
        fetchMessages()
    }
    
    //    @objc func onReceiveData(_ notification:Notification) {
    //        guard let bookclub = bookclub else {return}
    //        MessageController.shared.fetchNewMessages(for: bookclub, existingMessages: messagesArray) { (result) in
    //            DispatchQueue.main.async {
    //                switch result {
    //                case .success(let messages):
    //                    self.messagesArray.append(contentsOf: messages)
    //                    print("We made it this far")
    //                    self.tableView.reloadData()
    //                case .failure(_):
    //                    print("Could not fetch new messages")
    //                }
    //            }
    //        }
    //    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {return UITableViewCell()}
        
        let message = messagesArray[indexPath.row]
        print(message.text ?? "")
        cell.message = message
        
        //        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        //        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let messageToDelete = messagesArray[indexPath.row]
    //            guard let index = messagesArray.firstIndex(of: messageToDelete) else {return}
    //            guard let user = UserController.shared.currentUser else {return}
    //
    //            if messageToDelete.user == user.username {
    //                MessageController.shared.deleteMessage(message: messageToDelete) { (result) in
    //                    DispatchQueue.main.async {
    //                        switch result {
    //                        case .success(_):
    //                            self.messagesArray.remove(at: index)
    //                            self.tableView.reloadData()
    //                        case .failure(_):
    //                            print("Error deleting message")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let user = UserController.shared.currentUser else {return nil}
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed) in
            let messageToDelete = self.messagesArray[indexPath.row]
            guard let index = self.messagesArray.firstIndex(of: messageToDelete) else {return}
            if messageToDelete.user == user.username {
                MessageController.shared.deleteMessage(message: messageToDelete) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.messagesArray.remove(at: index)
                            self.tableView.reloadData()
                        case .failure(_):
                            print("Error deleting message")
                        }
                    }
                }
            }
        }
        let reportAction = UIContextualAction(style: .normal, title: "Report") { (action, view, actionPerformed) in
            let message = self.messagesArray[indexPath.row]
            let confirmReportController = UIAlertController(title: "Report Message?", message: nil, preferredStyle: .alert)
            let cancelReportAction = UIAlertAction(title: "Cancel", style: .cancel)
            let confirmReportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
                message.reportCount += 1
                if message.reportCount == 2 {
                    MessageController.shared.deleteMessage(message: message) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.fetchMessages()
                                self.reportConfirm()
                                self.userReportIncrease(username: message.user)
                            case .failure(_):
                                print("could not delete bookclub")
                            }
                        }
                    }
                } else {
                    MessageController.shared.updateMessage(message: message) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.reportConfirm()
                            case .failure(_):
                                print("could not update bookclub")
                            }
                        }
                    }
                }
            }
            confirmReportController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            confirmReportController.view.tintColor = .accentBlack
            confirmReportController.addAction(cancelReportAction)
            confirmReportController.addAction(confirmReportAction)
            
            self.present(confirmReportController, animated: true)
        }
        
        if messagesArray[indexPath.row].user == user.username {
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        } else {
            let configuration = UISwipeActionsConfiguration(actions: [reportAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
    }
    
    func reportConfirm() {
        let alertController = UIAlertController(title: nil, message: "Message has been reported", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Okay", style: .cancel)
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true)
    }
    
    func userReportIncrease(username: String) {
        UserController.shared.fetchUsername(username: username) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    user.reportCount += 1
                    if user.reportCount == 2 {
                        self.deleteAllBookclubs(user: user)
                        self.removeAllFollows(user: user)
                        UserController.shared.deleteUser(user: user) { (result) in }
                    } else {
                        UserController.shared.updateUser(user: user) { (result) in }
                    }
                case .failure(_):
                    print("Could not fetch bookclub admin")
                }
            }
        }
    }
    
    func removeAllFollows(user: User) {
        for followerUsername in user.followerList {
            UserController.shared.fetchUsername(username: followerUsername) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let follower):
                        guard let index = follower.followingList.firstIndex(of: user.username) else {return}
                        follower.followingList.remove(at: index)
                        UserController.shared.updateUser(user: follower) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    print("User's following list updated.")
                                case .failure(_):
                                    print("Error updating follower.")
                                }
                            }
                        }
                    case .failure(_):
                        print("Could not fetch follower.")
                    }
                }
            }
        }
        for followingUsername in user.followingList {
            UserController.shared.fetchUsername(username: followingUsername) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let following):
                        guard let index = following.followerList.firstIndex(of: user.username) else {return}
                        following.followerList.remove(at: index)
                        UserController.shared.updateUser(user: following) { (result) in }
                    case .failure(_):
                        print("Could not fetch following.")
                    }
                }
            }
        }
    }
    
    func deleteAllBookclubs(user: User) {
        var bookclubsToCheck: [Bookclub] = []
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookclubs):
                    bookclubsToCheck = bookclubs
                    checkBookclubs()
                case .failure(_):
                    print("Could not fetch bookclubs.")
                }
            }
        }

        func checkBookclubs() {
            for bookclub in bookclubsToCheck {
                if bookclub.admin == user.appleUserRef {
                    BookclubController.shared.delete(bookclub: bookclub) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                print("Successfully deleted bookclub")
                            case .failure(_):
                                print("Could not delete bookclub")
                            }
                        }
                    }
                } else {
                    guard let index = bookclub.members.firstIndex(of: user.appleUserRef) else {return}
                    bookclub.members.remove(at: index)
                    BookclubController.shared.update(bookclub: bookclub) { (result) in }
                }
            }
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "messagesToBCVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclub
            destination.bookclub = bookclubToSend
            
        }
    }
}
