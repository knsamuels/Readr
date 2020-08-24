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
    
    var bookclub: Bookclub? 
    var currentlyReading: Book?
    var pastReads: [Book] = []
    
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
        updateViews()
//                guard let bookclub = bookclub else {return}
//        bookclub.pastReads.append("0439358078")
//                print(bookclub.currentlyReading)
        fetchBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
         updateViews()
                fetchBook()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = bookclub else {return}
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        if userReference != bookclub.admin {
            print(user.bookclubs.count)
            if bookclub.members.contains(userReference) {
                guard let index = bookclub.members.firstIndex(of: userReference) else {return}
                
                bookclub.members.remove(at: index)
                joinButton.setTitle("Join", for: .normal)
                
            } else {
                user.bookclubs.append(bookclub)
                bookclub.members.append(userReference)
                joinButton.setTitle("Leave", for: .normal)
            }
        }
        print(bookclub.name)
        print(user.username)
        print(user.bookclubs.count)
        print(user.recordID)
        print(userReference)
        BookclubController.shared.update(bookclub: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("yes")
                case .failure(_):
                    print("no")
                }
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
            self.imageOfBookClub.image = bookclub.profilePicture
            self.descriptionOfBookClub.text = bookclub.description
            self.nameOfBookClub.text = bookclub.name
            self.meetingInfoForBookClub.text = bookclub.meetingInfo
            self.adminNameLabel.text = "\(bookclub.admin)"
            //this needs to be changed
            self.adminContactInfoLabel.text = bookclub.adminContactInfo
            if bookclub.admin == userReference {
                self.joinButton.setTitle("Host", for: .normal)
            } else if bookclub.members.contains(userReference) {
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
        if segue.identifier == "bcCurrentlyReadingImageToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = currentlyReading
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage1ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[0]
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage2ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[1]
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage3ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[2]
            destination.book = bookToSend
        }
    }
}
