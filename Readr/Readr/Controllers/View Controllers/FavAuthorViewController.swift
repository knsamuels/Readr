//
//  FavAuthorViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FavAuthorViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var favAuthorTextField: UITextField!
    @IBOutlet weak var blackView: UIView!
  
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let favAuthor = favAuthorTextField.text, !favAuthor.isEmpty else {return}
        user.favoriteAuthor = favAuthor
    }
    
} //End of class
