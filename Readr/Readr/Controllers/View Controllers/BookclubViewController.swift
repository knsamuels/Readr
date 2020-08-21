//
//  BookclubViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

class BookclubViewController: UIViewController {
    
    var bookclub: Bookclub? {
        didSet {
            updateViews()
        }
    }
    var currentlyReading: Book?
    
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UILabel!
    @IBOutlet weak var descriptionOfBookClub: UILabel!
    @IBOutlet weak var meetingInfoForBookClub: UILabel!
    @IBOutlet weak var ImageForCurrentlyReading: UIImageView!
    @IBOutlet weak var titleForCurrentlyReading: UILabel!
    @IBOutlet weak var authorForCurrentlyReading: UILabel!
    @IBOutlet weak var ratingForCurrentlyReading: UILabel!
    @IBOutlet weak var image1ForPastReads: UIImageView!
    @IBOutlet weak var title1ForPastReads: UILabel!
    @IBOutlet weak var author1ForPastReads: UILabel!
    @IBOutlet weak var rating1ForPastReads: UILabel!
    @IBOutlet weak var image2ForPastReads: UIImageView!
    @IBOutlet weak var title2ForPastReads: UILabel!
    @IBOutlet weak var author2ForPastReads: UILabel!
    @IBOutlet weak var rating2ForPastReads: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminContactInfoLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let bookclub = bookclub else {return}
//        bookclub.currentlyReading = "9780399230035"
//        print(bookclub.currentlyReading)
        fetchBook()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = bookclub else {return}
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        if userReference != bookclub.admin {
        if user.bookclubs.contains(bookclub) {
            guard let index = user.bookclubs.firstIndex(of: bookclub) else {return}
            guard let userIndex = bookclub.members.firstIndex(of: userReference) else {return}
            user.bookclubs.remove(at: index)
            bookclub.members.remove(at: userIndex)
            joinButton.setTitle("Join", for: .normal)
            
        } else {
            user.bookclubs.append(bookclub)
            bookclub.members.append(userReference)
            joinButton.setTitle("Leave", for: .normal)
        }
    }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = UserController.shared.currentUser else {return}
            guard let bookclub = self.bookclub else {return}
            guard let currentlyReading = self.currentlyReading else {return}
            let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
//            let adminUser = User(ckRecord: bookclub.admin.recordID)
//            let admin = adminUser.user
            self.descriptionOfBookClub.text = bookclub.description
            self.nameOfBookClub.text = bookclub.name
            self.meetingInfoForBookClub.text = bookclub.meetingInfo
            self.adminNameLabel.text = "\(bookclub.admin)"
            //this needs to be changed
            self.adminContactInfoLabel.text = bookclub.adminContactInfo
            if bookclub.admin == userReference {
                self.joinButton.setTitle("Host", for: .normal)
            } else if user.bookclubs.contains(bookclub) {
                self.joinButton.setTitle("Leave", for: .normal)
            } else {
                self.joinButton.setTitle("Join", for: .normal)
            }
            self.ImageForCurrentlyReading.image = currentlyReading.coverImage
            self.titleForCurrentlyReading.text = currentlyReading.title
            self.authorForCurrentlyReading.text = currentlyReading.authors?.first
            self.ratingForCurrentlyReading.text = "\(currentlyReading.averageRating)"
                
        }
    }

    func fetchBook() {
        guard let bookclub = bookclub else { return}
        BookController.fetchOneBookWith(ISBN: bookclub.currentlyReading) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let book):
                    self.currentlyReading = book
                    self.updateViews()
                case .failure(_):
                    print("error fetching book")
                }
            }
        }
    }
    func fetchBookClubs () {
        guard let user = UserController.shared.currentUser else { return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            switch result {
            case .success(let bookclubs):
                UserController.shared.currentUser?.bookclubs.append(contentsOf: bookclubs)
                self.updateViews()
                print("we were able to get the user's bookclubs")
            case .failure(_):
                print("we were not able to get the user's bookclubs")
            }
        }
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
}
