//
//  LogInViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/30/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var usernameTextField: ReadenTextField!
    @IBOutlet weak var passwordTextField: ReadenTextField!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    // MARK: -Properties
       var activeTextField : UITextField? = nil
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectLabel.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        
        UserController.shared.fetchUsername(username: username) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if password == user.password {
                        UserController.shared.currentUser = user
                        self.presentBookshelfVC()
                    } else {
                        self.incorrectLabel.isHidden = false
                    }
                case .failure(_):
                    print("Could not fetch user with that username")
                }
            }
        }
    }
    
    //MARK: - Helper functions
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if usernameTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
        }
        if passwordTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
            }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
    
    func presentBookshelfVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Readen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
} //End of class

extension LogInViewController: UITextFieldDelegate {
    func textFieldWillBeginEditing( textField: UITextField) {
        self.activeTextField = textField
        
    }
    
    func textFieldDidEndEditing( textField: UITextField) {
        self.activeTextField = nil
    }
}
