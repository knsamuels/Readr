//
//  JoinBCViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class CreateBCViewController: UIViewController {
    
    var bookclub: Bookclub?
    
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UITextField!
    @IBOutlet weak var descriptionOfBookClub: UITextView!
    @IBOutlet weak var meetingInfoForBookBlub: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingTitleLabel: UILabel!
    @IBOutlet weak var currentlyReadingAuthorLabel: UILabel!
    @IBOutlet weak var currentlyReadingRatingLabel: UILabel!
    @IBOutlet weak var createBookclubButton: UIButton!
    @IBOutlet weak var adminContactInfo: UITextField!
    @IBOutlet weak var memberCapacity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createBookclubButtonTapped(_ sender: UIButton) {
        guard let name = nameOfBookClub.text, !name.isEmpty,
            let adminContactInformation = adminContactInfo.text, !adminContactInformation.isEmpty, let description = descriptionOfBookClub.text, !description.isEmpty, let meetingInfo = meetingInfoForBookBlub.text, !meetingInfo.isEmpty, let memberCap = memberCapacity.text, !memberCap.isEmpty else {return}
        let profilePic: UIImage?
        if imageOfBookClub.image != nil {
            profilePic = imageOfBookClub.image
        } else {
            profilePic = UIImage(named: "not using")
        }
        if let bookclub = bookclub {
            BookclubController.shared.update(bookclub: bookclub) { (result) in
                switch result {
                case .success(let bookclub):
                    self.bookclub = bookclub
                    self.navigationController?.popViewController(animated: true)
                case .failure(_):
                    print("could not update the bookclub")
                }
            }
        } else {
            BookclubController.shared.createBookClub(name: name, adminContactInfo: adminContactInformation, description: description, profilePic: profilePic, meetingInfo: meetingInfo, memberCapacity: Int(memberCap) ?? 10 ) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bookclub):
                        self.bookclub = bookclub
                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

     // MARK: - Navigation
  
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "createBCtoVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclub
            destination.bookclub = bookclubToSend
        }
    }
}
