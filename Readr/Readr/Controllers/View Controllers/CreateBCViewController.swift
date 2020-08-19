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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func createBookclubButtonTapped(_ sender: UIButton) {
        guard let name = nameOfBookClub.text, !name.isEmpty else { return }
//            let adminContactInfo = "", !adminContactInfo.isEmpty,
        if let bookclub = bookclub {
            BookclubController.shared.update(bookclub: bookclub) { (result) in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(_):
                    print("could not update the bookclub")
                }
            }
        } else {
//            BookclubController.shared.createBookClub(name: <#T##String#>, adminContactInfo: <#T##String#>, description: <#T##String#>, profilePic: <#T##UIImage?#>, meetingInfo: <#T##String#>, memberCapacity: <#T##Int#>, completion: <#T##(Result<Bookclub, BookclubError>) -> Void#>)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
