//
//  FavAuthorViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FavAuthorViewController: UIViewController, UITextViewDelegate  {
    
    var activeTextField : UITextField? = nil
    
    //MARK: - Outlets
    @IBOutlet weak var favAuthorTextField: UITextField!
    @IBOutlet weak var blackView: UIView!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let favAuthor = favAuthorTextField.text, !favAuthor.isEmpty else {return}
        user.favoriteAuthor = favAuthor
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if favAuthorTextField.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
} //End of class

extension FavAuthorViewController: UITextFieldDelegate {
    func textFieldWillBeginEditing( textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing( textField: UITextField) {
        self.activeTextField = nil
    }
}

