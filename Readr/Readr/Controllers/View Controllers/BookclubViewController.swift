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

        // Do any additional setup after loading the view.
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
