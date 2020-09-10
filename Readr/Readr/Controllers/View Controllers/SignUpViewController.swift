//
//  UsernameViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextViewDelegate  {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var alreadyInUseLabel: UILabel!
  
    //MARK: Properties
    var activeTextField : UITextField? = nil
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        alreadyInUseLabel.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {return}
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {return}
        
        checkUsername(username: username)
    }
    
    //MARK: - Helper Methods
    func checkUsername(username: String) {
        UserController.shared.fetchUsername(username: username) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.alreadyInUseLabel.isHidden = false
                case .failure(_):
                    self.createUser()
                }
            }
        }
    }
    
    func createUser() {
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {return}
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {return}
        
        UserController.shared.createUser(username: username, firstName: firstName, lastName: lastName) { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                self.createFavorites()
                self.presentCustomizeVC()
            case .failure(let error):
                print(error.errorDescription ?? "There was an error creating a user.")
            }
        }
    }
    
    func createFavorites() {
        BookshelfController.shared.createBookshelf(title: "Favorites", color: "blue") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Favorites added!")
                case .failure(_):
                    print("Favorites failed.")
                }
            }
        }
    }
    
    func presentCustomizeVC() {
        DispatchQueue.main.async {
            let customizeVC = UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "customizeVC")
            customizeVC.modalPresentationStyle = .fullScreen
            self.present(customizeVC, animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
            }
        
        if usernameTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
} //End of class
    
extension SignUpViewController: UITextFieldDelegate {
  func textFieldWillBeginEditing( textField: UITextField) {
    self.activeTextField = textField
  }

  func textFieldDidEndEditing( textField: UITextField) {
    self.activeTextField = nil
  }
}
