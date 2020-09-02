//
//  FirstNameViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/30/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FirstNameViewController: UIViewController  {
    
    //MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
   
    // MARK: -Properties
    var activeTextField : UITextField? = nil
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Helper functions
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if firstNameTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
        }
        if lastNameTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
            }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
    
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

extension FirstNameViewController: UITextFieldDelegate {
    func textFieldWillBeginEditing( textField: UITextField) {
        self.activeTextField = textField
        
    }
    
    func textFieldDidEndEditing( textField: UITextField) {
        self.activeTextField = nil
    }
}
