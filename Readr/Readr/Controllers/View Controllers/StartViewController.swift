//
//  SignInViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/17/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        signInButton.isHidden = true
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard UserController.shared.currentUser == nil else {
            self.presentBookshelfVC()
            return
        }
    }
    
    //MARK: - Helper Methods
    private func setUpViews() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                self.presentBookshelfVC()
            case .failure(let error):
                print(error.errorDescription ?? "There was an error fetching user")
            }
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
