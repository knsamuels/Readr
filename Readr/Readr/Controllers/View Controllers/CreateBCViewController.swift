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
    var memberCapacity = 10
    var currentlyReadingBook: Book? {
        didSet {
            updateCurrentlyReading()
        }
    }
    
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UITextField!
    @IBOutlet weak var descriptionOfBookClub: UITextView!
    @IBOutlet weak var meetingInfoForBookBlub: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingButton: UIButton!
    @IBOutlet weak var createBookclubButton: UIButton!
    @IBOutlet weak var selectProfileImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
            let description = descriptionOfBookClub.text, !description.isEmpty,
            let meetingInfo = meetingInfoForBookBlub.text, !meetingInfo.isEmpty,
            let isbn = currentlyReadingBook?.industryIdentifiers?.first?.identifier else {return}
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
                    //                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        print("could not update the bookclub")
                    }
                }
            }
        } else {
            BookclubController.shared.createBookClub(name: name, adminContactInfo: "never", description: description, profilePic: profilePic, meetingInfo: meetingInfo, memberCapacity: memberCapacity, currentlyReading: isbn) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bookclub):
                        self.bookclub = bookclub
                        self.performSegue(withIdentifier:
                            "toBookclubVC", sender: self)
                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func currentlyReadingButtonTapped(_ sender: Any) {
        
        guard let bookPopUpTBVC = UIStoryboard(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "PopUpBookSearch") as? PopUpBooksSearchTableViewController else {return}
        bookPopUpTBVC.modalPresentationStyle = .automatic
        bookPopUpTBVC.bookDelegate = self
        self.present(bookPopUpTBVC, animated: true, completion: nil)
    }
    
    @IBAction func fiveMembersTapped(_ sender: Any) {
        memberCapacity = 5
    }
    
    @IBAction func tenMembersButtonTapped(_ sender: Any) {
        memberCapacity = 10
    }
    
    @IBAction func fifteenMemberButtonTapped(_ sender: Any) {
        memberCapacity = 15
    }
    
    @IBAction func twentyMembersButtonTapped(_ sender: Any) {
        memberCapacity = 20
    }
    
    @IBAction func twentyFivePlusMembersTapped(_ sender: Any) {
        memberCapacity = 100
    }
    
    
    //MARK: - Helpers
    
    func presentBookclub(bookclub: Bookclub) {
        guard let bookclubVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "BookclubVC") as? BookclubViewController else {return}
        bookclubVC.modalPresentationStyle = .fullScreen
        bookclubVC.bookclub = bookclub
        self.present(bookclubVC, animated: true, completion: nil)
    }
    
    func setupTextViews() {
        descriptionOfBookClub.delegate = self
        
        if descriptionOfBookClub.text.isEmpty {
            descriptionOfBookClub.text = "Introduce your bookclub!"
            descriptionOfBookClub.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == descriptionOfBookClub {
                textView.text = "Introduce your bookclub!"
            }
            textView.textColor = UIColor.black
        }
    }
    
    func updateCurrentlyReading() {
        guard let book = currentlyReadingBook else {return}
        currentlyReadingImage.image = book.coverImage
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookclubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclub
            destination.bookclub = bookclubToSend
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

extension CreateBCViewController: PopUpBookSearchDelegate {
    func didSelectBook(book: Book) {
        currentlyReadingBook = book
        
    }
}
