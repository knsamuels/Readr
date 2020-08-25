//
//  JoinBCViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class CreateBCViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var bookclub: Bookclub?
    
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UITextField!
    @IBOutlet weak var descriptionOfBookClub: UITextView!
    @IBOutlet weak var meetingInfoForBookBlub: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingTitleLabel: UILabel!
    @IBOutlet weak var currentlyReadingAuthorLabel: UILabel!
    @IBOutlet weak var currentlyReadingRatingLabel: UILabel!
    @IBOutlet weak var createBookclubButton: UIButton!
    @IBOutlet weak var adminContactInfo: UITextField!
    @IBOutlet weak var memberCapacity: UITextField!
    @IBOutlet weak var selectProfileImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectProfileImageButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Select an image", message: "From where would you like to select an image?", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func createBookclubButtonTapped(_ sender: UIButton) {
        guard let name = nameOfBookClub.text, !name.isEmpty,
            let adminContactInformation = adminContactInfo.text, !adminContactInformation.isEmpty, let description = descriptionOfBookClub.text, !description.isEmpty, let meetingInfo = meetingInfoForBookBlub.text, !meetingInfo.isEmpty, let memberCap = memberCapacity.text, !memberCap.isEmpty else {return}
        let profilePic: UIImage?
        if imageOfBookClub.image != nil {
            profilePic = imageOfBookClub.image
        } else {
            profilePic = UIImage(named: "RLogo")
        }
        if let bookclub = bookclub {
            BookclubController.shared.update(bookclub: bookclub) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bookclub):
                        self.bookclub = bookclub
                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        print("could not update the bookclub")
                    }
                }
            }
        } else {
            BookclubController.shared.createBookClub(name: name, adminContactInfo: adminContactInformation, description: description, profilePic: profilePic, meetingInfo: meetingInfo, memberCapacity: Int(memberCap) ?? 10 ) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bookclub):
                        self.bookclub = bookclub
                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    //MARK: - Helpers
    
    func setupTextViews() {
        descriptionOfBookClub.delegate = self
        
        if descriptionOfBookClub.text.isEmpty {
            descriptionOfBookClub.text = "Describe your bookclub..."
            descriptionOfBookClub.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == descriptionOfBookClub {
                textView.text = "Describe your bookclub..."
                
                textView.textColor = UIColor.lightGray
            }
        }
        
        
        // MARK: - Navigation
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "createBCtoVC" {
                guard let destination = segue.destination as? BookclubViewController else {return}
                let bookclubToSend = bookclub
                destination.bookclub = bookclubToSend
            }
        }
    }
}
extension CreateBCViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        selectProfileImage.setTitle("", for: .normal)
        imageOfBookClub.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
} //End of extension

