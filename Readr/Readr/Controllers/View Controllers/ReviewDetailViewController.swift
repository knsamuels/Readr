//
//  ReviewDetailViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import WebKit

class ReviewDetailViewController: UIViewController {

    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var reviewsView: WKWebView!
    @IBOutlet weak var goodReadsLabel: UILabel!
   
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
