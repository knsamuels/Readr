//
//  SignInViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/17/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var favAuthorTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var alreadyExistsLabel: UILabel!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleToLogIn()
        fetchUser()
        alreadyExistsLabel.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    @IBAction func logInButtonSelected(_ sender: Any) {
        toggleToLogIn()
    }
    @IBAction func signUpButtonSelected(_ sender: Any) {
        toggleToSignUp()
    }
    @IBAction func enterButtonTapped(_ sender: Any) {
        guard UserController.shared.currentUser == nil else {
            self.presentMessageVC()
            return
        }
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {return}
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {return}
        guard let favAuthor = favAuthorTextField.text, !favAuthor.isEmpty else {return}
        checkUsername(username: username)
    }
    
    //MARK: - Helper Methods
    func checkUsername(username: String) {
        UserController.shared.fetchUsername(username: username) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.alreadyExistsLabel.isHidden = false
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
        guard let favAuthor = favAuthorTextField.text, !favAuthor.isEmpty else {return}
        UserController.shared.createUser(username: username, firstName: firstName, lastName: lastName, favoriteAuthor: favAuthor) { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                self.createFavorites()
                self.presentMessageVC()
            case .failure(let error):
                print(error.errorDescription ?? "There was an error creating a user.")
            }
        }
    }
    
    func createFavorites() {
           BookshelfController.shared.createBookshelf(title: "Favorites") { (result) in
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
    
    func toggleToLogIn() {
        confirmTextField.isHidden = true
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        favAuthorTextField.isHidden = true
        logInButton.tintColor = .blue
        signUpButton.tintColor = .lightGray
        enterButton.setTitle("Log In", for: .normal)
    }
    
    func toggleToSignUp() {
        confirmTextField.isHidden = false
        firstNameTextField.isHidden = false
        lastNameTextField.isHidden = false
        favAuthorTextField.isHidden = false
        logInButton.tintColor = .lightGray
        signUpButton.tintColor = .blue
        enterButton.setTitle("Sign Up", for: .normal)
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                self.presentMessageVC()
            case .failure(let error):
                print(error.errorDescription ?? "There was an error fetching user")
            }
        }
    }
    
    func presentMessageVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Readen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
} //End of class
