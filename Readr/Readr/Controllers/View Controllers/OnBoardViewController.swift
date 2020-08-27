//
//  OnBoardViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class OnBoardViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var favAuthorTextField: UITextField!
    
    //MARK: - Properties

    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bio = bioTextView.text, !bio.isEmpty else {return}
        guard let favAuthor = favAuthorTextField.text, !favAuthor.isEmpty else {return}
        
        user.bio = bio
        user.favoriteAuthor = favAuthor
        
        UserController.shared.updateUser(user: user) { (result) in
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: "toGenreVC", sender: self)
            case .failure(_):
                print("Failed to update User.")
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenreVC" {
            guard let destination = segue.destination as? GenresViewController else {return}
            guard let user = UserController.shared.currentUser else {return}
            destination.user = user
        }
    }
    

} //End of class
