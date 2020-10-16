//
//  MemberTableViewCell.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/16/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var dotsStackView: UIStackView!
    
    //MARK: - Properties
    var member: User? {
        didSet{
            updateViews()
        }
    }
    var bookclub: Bookclub?
    
    //MARK: _ Actions
    @IBAction func optionButtonTapped(_ sender: Any) {
    
    }
    
    //MARK: - Helper Methods
    
    func updateViews() {
        guard let member = member else {return}
        memberName.text = "\(member.firstName) \(member.lastName)"
        if let image = member.profilePhoto {
            memberImage.image = image
        } else {
            memberImage.image = member.profilePhoto ?? UIImage(named: "ReadenLogoWhiteSpace")
        }
        memberImage.layer.cornerRadius = memberImage.frame.height / 2
        memberImage.clipsToBounds = true
    }
    
    func presentOptionAlert() {
        guard let bookclub = bookclub,
            let member = member else {return}
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let removeAction = UIAlertAction(title: "Remove", style: .default) { (_) in
            print("remove")
        }
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            let confirmBlockController = UIAlertController(title: "Block User?", message: "You will never be able to unblock once you block.", preferredStyle: .alert)
            let cancelBlockAction = UIAlertAction(title: "Cancel", style: .cancel)
            let confirmBlockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
                bookclub.blockedUsers.append(member.username)
                
                BookclubController.shared.update(bookclub: bookclub) { (result) in
                    switch result {
                    case .success(_):
                        UserController.shared.updateUser(user: member) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    print("Success")
                                case .failure(_):
                                    print("could not update the user")
                                }
                            }
                        }
                    case .failure(_):
                        print("could not update the bookclub")
                    }
                }
            }
            confirmBlockController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            confirmBlockController.view.tintColor = .accentBlack
            confirmBlockController.addAction(cancelBlockAction)
            confirmBlockController.addAction(confirmBlockAction)
//            self.present(confirmBlockController, animated: true)
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(blockAction)
        
//        self.present(alertController, animated: true)
    }
} //End of class
