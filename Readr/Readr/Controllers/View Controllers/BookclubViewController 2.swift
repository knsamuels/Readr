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
        fetchBookClubs()
//        createBookClub()
        
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
    }
    
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = UserController.shared.currentUser else {return}
            self.descriptionOfBookClub.text = user.bookclubs[0].description
            self.nameOfBookClub.text = user.bookclubs[0].name
            self.meetingInfoForBookClub.text = user.bookclubs[0].meetingInfo
            self.adminNameLabel.text = user.username
            self.adminContactInfoLabel.text = user.bookclubs[0].adminContactInfo
        }
    }
    
    func createBookClub() {
        BookclubController.shared.createBookClub(name: "Harry Potter Fans", adminContactInfo: "kristin@email.com", description: "We love Harry Potter", profilePic: nil, meetingInfo: "Once a month", memberCapacity: 10) { (result) in
            switch result {
            case .success(let bookclub):
                guard let user = UserController.shared.currentUser else {return}
                let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
                bookclub.members.append(reference)
                print("creating the bookclub worked")
            case .failure(_):
                print("oh no we couldn't create a bookclub")
            }
        }
    }
    
//    func addBookClub() {
//        UserController.shared.currentUser
//
//    }
    
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
//    BookclubController.shared.createBookClub(name: "We love the Notebook", adminContactInfo: "kristin@email.com", description: "Talk about romance movies", profilePic: nil, meetingInfo: " first Monday of the month", memberCapacity: 15) { (result) in
//    switch result {
//    case .success(let bookclub):
//    UserController.shared.currentUser?.bookclub.append(bookclub)
//    self.updateViews()
//    print("this worked")
//    case .failure(_):
//    print("oh no the bookclub didn't work")
//    }
//    }
//}
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
