//
//  FirstNameViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/30/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FirstNameViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
//    if firstNameTextField.isEditing {
//    self.view.window?.frame.origin.y = -keyboardSize.height
//    }
//    if lastNameTextField.isEditing {
//    self.view.window?.frame.origin.y = -keyboardSize.height
//    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {return}
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {return}
        
        if segue.identifier == "toUsernameVC" {
            guard let destination = segue.destination as? UsernameViewController else {return}
            destination.firstName = firstName
            destination.lastName = lastName
        }
    }
    
} //End of class
