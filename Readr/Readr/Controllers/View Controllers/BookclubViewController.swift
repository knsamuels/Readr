//
//  BookclubViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookclubViewController: UIViewController {
    
    @IBOutlet weak var bookClubMainImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var meetingInfoTextView: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingTitle: UILabel!
    @IBOutlet weak var currentlyReadingAuthor: UILabel!
    @IBOutlet weak var currentlyReadingRating: UILabel!
    @IBOutlet weak var pastReadsImage: UIImageView!
    @IBOutlet weak var pastReadsTitle: UILabel!
    @IBOutlet weak var pastReadsAuthor: UILabel!
    @IBOutlet weak var pastReadsRating: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchBookClubs()
        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = UserController.shared.currentUser else {return}
            self.descriptionTextView.text = user.bookclubs[0].description
        }
    }
//
//    func fetchBookClubs () {
//        BookclubController.shared.createBookClub(name: "Harry Potter Fans", adminContactInfo: "kristin@email.com", description: "We love Harry Potter", profilePic: nil, meetingInfo: "Once a month", memberCapacity: 10) { (result) in
//            switch result {
//            case .success(let bookclub):
////                let reference = CKRecord.Reference(recordID: UserController.shared.currentUser?.recordID, action: .none)
//                bookclub.members.append(reference)
//                self.updateViews()
//                print("this worked")
//            case .failure(_):
//                print("oh no the bookclub didn't work")
//            }
//        }
//        guard let user = UserController.shared.currentUser else { return}
//        BookclubController.shared.fetchUsersBookClub(user: user) { (result) in
//            switch result {
//            case .success(_):
//                self.updateViews()
//                print("we were able to get the user's bookclubs")
//            case .failure(_):
//                print("we were not able to get the user's bookclubs")
//            }
//        }
//    }
    //        BookclubController.shared.createBookClub(name: "We love the Notebook", adminContactInfo: "kristin@email.com", description: "Talk about romance movies", profilePic: nil, meetingInfo: " first Monday of the month", memberCapacity: 15) { (result) in
    //            switch result {
    //            case .success(let bookclub):
    //                UserController.shared.currentUser?.bookclub.append(bookclub)
    //                self.updateViews()
    //                print("this worked")
    //            case .failure(_):
    //                print("oh no the bookclub didn't work")
    //            }
    //        }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

}
