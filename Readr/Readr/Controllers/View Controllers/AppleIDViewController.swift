//
//  AppleIDViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/28/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class AppleIDViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var iCloudStackView: UIStackView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        iCloudStackView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAppleUser()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchAppleUser),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - Helpers
    @objc func fetchAppleUser() {
        UserController.shared.fetchAppleUserReference { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.presentLoginVC()
                case .failure(_):
                    self.iCloudStackView.isHidden = false
                }
            }
        }
    }
    
    func presentLoginVC() {
        let logIn = UIStoryboard(name: "LogIn", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginVC")
        logIn.modalPresentationStyle = .fullScreen
        self.present(logIn, animated: true, completion: nil)
    }
}  //End of class
