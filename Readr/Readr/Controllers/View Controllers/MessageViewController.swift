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
        MessageController.shared.fetchMessages(for: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self.messagesArray = messages
                    self.tableView.reloadData()
                    print("testing to see if we can fetch messages")
                    if self.messagesArray.count > 0 {
                        let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                case .failure(_):
                    print("Error fetching messages")
                }
            }
        }
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
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {return UITableViewCell()}
        
        let message = messagesArray[indexPath.row]
        
        cell.message = message
        
        //        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        //        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let messageToDelete = messagesArray[indexPath.row]
            guard let index = messagesArray.firstIndex(of: messageToDelete) else {return}
            guard let user = UserController.shared.currentUser else {return}
            
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
