//
//  JoinBCViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class CreateBCViewController: UIViewController {

    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UITextField!
    @IBOutlet weak var descriptionOfBookClub: UITextView!
    @IBOutlet weak var meetingInfoForBookBlub: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingTitleLabel: UILabel!
    @IBOutlet weak var currentlyReadingAuthorLabel: UILabel!
    @IBOutlet weak var currentlyReadingRatingLabel: UILabel!
    @IBOutlet weak var pastReadsImage: UIImageView!
    @IBOutlet weak var pastReadsTitleLabel: UILabel!
    @IBOutlet weak var pastReadsAuthorLabel: UILabel!
    @IBOutlet weak var pastReadsRatingLabel: UILabel!
    @IBOutlet weak var createBookclubButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func createBookclubButtonTapped(_ sender: UIButton) {
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
