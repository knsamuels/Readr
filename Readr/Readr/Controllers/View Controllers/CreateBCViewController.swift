//
//  JoinBCViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class CreateBCViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var activeTextField : UITextField? = nil
    var bookclub: Bookclub?
    var memberCapacity = 10
    var pastReads: [String] = []
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
    @IBOutlet weak var doneReadingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        nameOfBookClub.delegate = self
        meetingInfoForBookBlub.delegate = self
        doneReadingButton.isHidden = true
        if let bookclub = bookclub {
            updateViews(bookclub: bookclub)
            doneReadingButton.isHidden = false
            currentlyReadingButton.isHidden = true
        }
    }
    // MARK: - Actions
    
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
        createBookclubButton.isEnabled = false
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
            bookclub.description = description
            bookclub.name = name
            bookclub.meetingInfo = meetingInfo
            bookclub.memberCapacity = memberCapacity
            bookclub.currentlyReading = isbn
            bookclub.profilePicture = profilePic
            bookclub.pastReads = pastReads
            BookclubController.shared.update(bookclub: bookclub) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("this worked")
                        self.dismiss(animated: true)
                    case .failure(_):
                        print("could not update the bookclub")
                    }
                }
            }
        } else {
            BookclubController.shared.createBookClub(name: name, adminContactInfo: "", description: description, profilePic: profilePic, meetingInfo: meetingInfo, memberCapacity: memberCapacity, currentlyReading: isbn) { (result) in
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
        currentlyReadingButton.isHidden = true
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
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        //self.dismiss(animated: true)
    }
    
    @IBAction func doneReadingTapped(_ sender: UIButton) {
        guard let bookclub = bookclub else {return}
        pastReads.append(bookclub.currentlyReading)
        currentlyReadingBook = nil
        currentlyReadingImage.image = UIImage(named: "RLogo")
        doneReadingButton.isEnabled = false
        currentlyReadingButton.isHidden = false 
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
            }
        
        if meetingInfoForBookBlub.isEditing {
            self.view.window?.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            self.view.window?.frame.origin.y = 0
        }
    }
    
    func fetchCurrentlyReadingBook(bookclub: Bookclub){
        let isbn = bookclub.currentlyReading
        BookController.fetchOneBookWith(ISBN: isbn) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let book):
                    self.currentlyReadingBook = book
                case .failure(_):
                    print("could not fetch the bookclub for that isbn")
                }
            }
        }
    }
    
    func updateViews(bookclub: Bookclub) {
        imageOfBookClub.image = bookclub.profilePicture
        nameOfBookClub.text = bookclub.name
        descriptionOfBookClub.text = bookclub.description
        meetingInfoForBookBlub.text = bookclub.meetingInfo
        createBookclubButton.setTitle("Save", for: .normal)
        fetchCurrentlyReadingBook(bookclub: bookclub)
        pastReads = bookclub.pastReads
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

extension CreateBCViewController: UITextFieldDelegate {
  func textFieldWillBeginEditing( textField: UITextField) {
    self.activeTextField = textField
  }

  func textFieldDidEndEditing( textField: UITextField) {
    self.activeTextField = nil
  }
}
