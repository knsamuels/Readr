//
//  JoinBCViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol ReloadBookclubsDelegate: AnyObject {
    func reloadUserBookclubs()
}

class CreateBCViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var nameOfBookClub: UITextField!
    @IBOutlet weak var descriptionOfBookClub: UITextView!
    @IBOutlet weak var meetingInfoForBookBlub: UITextField!
    @IBOutlet weak var currentlyReadingImage: UIImageView!
    @IBOutlet weak var currentlyReadingButton: UIButton!
    @IBOutlet weak var createBookclubButton: UIButton!
    @IBOutlet weak var selectProfileImage: UIButton!
    @IBOutlet weak var doneReadingButton: UIButton!
    @IBOutlet weak var fiveButton: circleButton!
    @IBOutlet weak var tenButton: circleButton!
    @IBOutlet weak var fifteenButton: circleButton!
    @IBOutlet weak var twentyButton: circleButton!
    @IBOutlet weak var twentyFiveButton: circleButton!
    @IBOutlet weak var cancelButtonToBC: UIButton!
    @IBOutlet weak var cancelButtonToUser: UIButton!
    
    //MARK: - Properties
    var activeTextField : UITextField? = nil
    var bookclub: Bookclub?
    var memberCapacity = 10
    var pastReads: [String] = []
    var fiveSelected: Bool = false
    var tenSelected: Bool = false
    var fifteenSelected: Bool = false
    var twentySelected: Bool = false
    var twentyFiveSelected: Bool = false
    var currentlyReadingBook: Book? {
        didSet {
            updateCurrentlyReading()
        }
    }
    weak var reloadBCDelegate: ReloadBookclubsDelegate?
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
        updateButtonColor()
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func selectProfileImageButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Select an image", message: "From where would you like to select an image?", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func createBookclubButtonTapped(_ sender: UIButton) {
        guard let name = nameOfBookClub.text, !name.isEmpty else {return}
        guard let description = descriptionOfBookClub.text, !description.isEmpty else {return}
        guard let meetingInfo = meetingInfoForBookBlub.text, !meetingInfo.isEmpty else {return}
        guard let industryIdentifiers = currentlyReadingBook?.industryIdentifiers else {return}
        createBookclubButton.isEnabled = false
        createBookclubButton.setTitleColor(.gray, for: .normal)
        var isbn = ""
        for industryIdentifier in industryIdentifiers {
            if industryIdentifier.type == "ISBN_13" {
                isbn = industryIdentifier.identifier
            }
        }
        if isbn == "" {
            isbn = industryIdentifiers.first?.identifier ?? ""
        }
        
        let profilePic: UIImage?
        if imageOfBookClub.image != nil && imageOfBookClub.image != UIImage(named: "RLogo") {
            profilePic = imageOfBookClub.image
        } else {
            profilePic = UIImage(named: "ReadenLogo")
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
                        BookclubController.shared.addSubscriptionTo(messagesForBookclub: bookclub) { (result, error) in }
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
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func currentlyReadingButtonTapped(_ sender: Any) {
        currentlyReadingButton.isHidden = true
        guard let bookPopUpTBVC = UIStoryboard(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "PopUpBookSearch") as? PopUpBooksSearchTableViewController else {return}
        bookPopUpTBVC.modalPresentationStyle = .automatic
        bookPopUpTBVC.bookDelegate = self
        self.present(bookPopUpTBVC, animated: true, completion: nil)
    }
    
    @IBAction func doneReadingTapped(_ sender: UIButton) {
        guard let bookclub = bookclub else {return}
        pastReads.append(bookclub.currentlyReading)
        currentlyReadingBook = nil
        currentlyReadingImage.image = UIImage(named: "RLogo")
        doneReadingButton.isEnabled = false
        currentlyReadingButton.isHidden = false
    }
    
    @IBAction func fiveMembersTapped(_ sender: Any) {
        memberCapacity = 5
        fiveSelected = true
        tenSelected = false
        fifteenSelected = false
        twentySelected = false
        twentyFiveSelected = false
        updateButtonColor()
    }
    
    @IBAction func tenMembersButtonTapped(_ sender: Any) {
        memberCapacity = 10
        fiveSelected = false
        tenSelected = true
        fifteenSelected = false
        twentySelected = false
        twentyFiveSelected = false
        updateButtonColor()
    }
    
    @IBAction func fifteenMemberButtonTapped(_ sender: Any) {
        memberCapacity = 15
        fiveSelected = false
        tenSelected = false
        fifteenSelected = true
        twentySelected = false
        twentyFiveSelected = false
        updateButtonColor()
    }
    
    @IBAction func twentyMembersButtonTapped(_ sender: Any) {
        memberCapacity = 20
        fiveSelected = false
        tenSelected = false
        fifteenSelected = false
        twentySelected = true
        twentyFiveSelected = false
        updateButtonColor()
    }
    
    @IBAction func twentyFivePlusMembersTapped(_ sender: Any) {
        memberCapacity = 100
        fiveSelected = false
        tenSelected = false
        fifteenSelected = false
        twentySelected = false
        twentyFiveSelected = true
        updateButtonColor()
    }
    
    //MARK: - Helper Methods
    private func setUpViews() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateBCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameOfBookClub.delegate = self
        meetingInfoForBookBlub.delegate = self
        doneReadingButton.isHidden = true
        if let bookclub = bookclub {
            cancelButtonToBC.isHidden = false
            cancelButtonToUser.isHidden = true
            updateViews(bookclub: bookclub)
            updateButtonColor()
            doneReadingButton.isHidden = false
            currentlyReadingButton.isHidden = true
        } else {
            tenSelected = true
            updateButtonColor()
            cancelButtonToBC.isHidden = true
            cancelButtonToUser.isHidden = false
        }
    }
    
    func setupTextViews() {
        meetingInfoForBookBlub.layer.borderWidth = 1.0
        meetingInfoForBookBlub.layer.borderColor = UIColor.black.cgColor
        
        descriptionOfBookClub.delegate = self
        descriptionOfBookClub.layer.borderWidth = 1.0
        descriptionOfBookClub.layer.borderColor = UIColor.black.cgColor
        
        if descriptionOfBookClub.text.isEmpty {
            descriptionOfBookClub.text = "Introduce your bookclub!"
            descriptionOfBookClub.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Introduce your bookclub!" {
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
    
    func updateCurrentlyReading() {
        guard let book = currentlyReadingBook else {return}
        currentlyReadingImage.image = book.coverImage
    }
    
    func updateViews(bookclub: Bookclub) {
        if let image = bookclub.profilePicture {
            imageOfBookClub.image = image
        } else {
            imageOfBookClub.image = UIImage(named: "ReadenLogoWhiteSpace")
        }
        imageOfBookClub.layer.cornerRadius = imageOfBookClub.frame.height / 2
        imageOfBookClub.clipsToBounds = true
        selectProfileImage.setTitle("", for: .normal)
        
        nameOfBookClub.text = bookclub.name
        descriptionOfBookClub.text = bookclub.description
        meetingInfoForBookBlub.text = bookclub.meetingInfo
        createBookclubButton.setTitle("Save", for: .normal)
        fetchCurrentlyReadingBook(bookclub: bookclub)
        pastReads = bookclub.pastReads
        
        if bookclub.memberCapacity == 5 {
            fiveSelected = true
            memberCapacity = 5
        } else if bookclub.memberCapacity == 10 {
            tenSelected = true
            memberCapacity = 10
        } else if bookclub.memberCapacity == 15 {
            fifteenSelected = true
            memberCapacity = 15
        } else if bookclub.memberCapacity == 20 {
            twentySelected = true
            memberCapacity = 20
        } else if bookclub.memberCapacity == 100 {
            twentyFiveSelected = true
            memberCapacity = 100
        }
        updateButtonColor()
    }
    
    func updateButtonColor() {
        if fiveSelected {
            fiveButton.layer.borderColor = UIColor.readenBlue.cgColor
            fiveButton.setTitleColor(.readenBlue, for: .normal)
            fiveButton.layer.borderWidth = 3.0
            fiveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            tenButton.layer.borderColor = UIColor.black.cgColor
            tenButton.setTitleColor(.black, for: .normal)
            tenButton.layer.borderWidth = 1.0
            tenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            fifteenButton.layer.borderColor = UIColor.black.cgColor
            fifteenButton.setTitleColor(.black, for: .normal)
            fifteenButton.layer.borderWidth = 1.0
            fifteenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyButton.layer.borderColor = UIColor.black.cgColor
            twentyButton.setTitleColor(.black, for: .normal)
            twentyButton.layer.borderWidth = 1.0
            twentyButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyFiveButton.layer.borderColor = UIColor.black.cgColor
            twentyFiveButton.setTitleColor(.black, for: .normal)
            twentyFiveButton.layer.borderWidth = 1.0
            twentyFiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            
        } else if tenSelected {
            fiveButton.layer.borderColor = UIColor.black.cgColor
            fiveButton.setTitleColor(.black, for: .normal)
            fiveButton.layer.borderWidth = 1.0
            fiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            tenButton.layer.borderColor = UIColor.readenBlue.cgColor
            tenButton.setTitleColor(.readenBlue, for: .normal)
            tenButton.layer.borderWidth = 3.0
            tenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            fifteenButton.layer.borderColor = UIColor.black.cgColor
            fifteenButton.setTitleColor(.black, for: .normal)
            fifteenButton.layer.borderWidth = 1.0
            fifteenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyButton.layer.borderColor = UIColor.black.cgColor
            twentyButton.setTitleColor(.black, for: .normal)
            twentyButton.layer.borderWidth = 1.0
            twentyButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyFiveButton.layer.borderColor = UIColor.black.cgColor
            twentyFiveButton.setTitleColor(.black, for: .normal)
            twentyFiveButton.layer.borderWidth = 1.0
            twentyFiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            
        } else if fifteenSelected {
            fiveButton.layer.borderColor = UIColor.black.cgColor
            fiveButton.setTitleColor(.black, for: .normal)
            fiveButton.layer.borderWidth = 1.0
            fiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            tenButton.layer.borderColor = UIColor.black.cgColor
            tenButton.setTitleColor(.black, for: .normal)
            tenButton.layer.borderWidth = 1.0
            tenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            fifteenButton.layer.borderColor = UIColor.readenBlue.cgColor
            fifteenButton.setTitleColor(.readenBlue, for: .normal)
            fifteenButton.layer.borderWidth = 3.0
            fifteenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            twentyButton.layer.borderColor = UIColor.black.cgColor
            twentyButton.setTitleColor(.black, for: .normal)
            twentyButton.layer.borderWidth = 1.0
            twentyButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyFiveButton.layer.borderColor = UIColor.black.cgColor
            twentyFiveButton.setTitleColor(.black, for: .normal)
            twentyFiveButton.layer.borderWidth = 1.0
            twentyFiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            
        } else if twentySelected {
            fiveButton.layer.borderColor = UIColor.black.cgColor
            fiveButton.setTitleColor(.black, for: .normal)
            fiveButton.layer.borderWidth = 1.0
            fiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            tenButton.layer.borderColor = UIColor.black.cgColor
            tenButton.setTitleColor(.black, for: .normal)
            tenButton.layer.borderWidth = 1.0
            tenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            fifteenButton.layer.borderColor = UIColor.black.cgColor
            fifteenButton.setTitleColor(.black, for: .normal)
            fifteenButton.layer.borderWidth = 1.0
            fifteenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyButton.layer.borderColor = UIColor.readenBlue.cgColor
            twentyButton.setTitleColor(.readenBlue, for: .normal)
            twentyButton.layer.borderWidth = 3.0
            twentyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            twentyFiveButton.layer.borderColor = UIColor.black.cgColor
            twentyFiveButton.setTitleColor(.black, for: .normal)
            twentyFiveButton.layer.borderWidth = 1.0
            twentyFiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            
        } else if twentyFiveSelected {
            fiveButton.layer.borderColor = UIColor.black.cgColor
            fiveButton.setTitleColor(.black, for: .normal)
            fiveButton.layer.borderWidth = 1.0
            fiveButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            tenButton.layer.borderColor = UIColor.black.cgColor
            tenButton.setTitleColor(.black, for: .normal)
            tenButton.layer.borderWidth = 1.0
            tenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            fifteenButton.layer.borderColor = UIColor.black.cgColor
            fifteenButton.setTitleColor(.black, for: .normal)
            fifteenButton.layer.borderWidth = 1.0
            fifteenButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyButton.layer.borderColor = UIColor.black.cgColor
            twentyButton.setTitleColor(.black, for: .normal)
            twentyButton.layer.borderWidth = 1.0
            twentyButton.titleLabel?.font = UIFont(name: "Cochin", size: 17)
            twentyFiveButton.layer.borderColor = UIColor.readenBlue.cgColor
            twentyFiveButton.setTitleColor(.readenBlue, for: .normal)
            twentyFiveButton.layer.borderWidth = 3.0
            twentyFiveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    func presentBookclub(bookclub: Bookclub) {
        guard let bookclubVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "BookclubVC") as? BookclubViewController else {return}
        bookclubVC.modalPresentationStyle = .fullScreen
        bookclubVC.bookclub = bookclub
        self.present(bookclubVC, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookclubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = bookclub
            destination.bookclub = bookclubToSend
            destination.chainDelegate = self 
        }
    }
} //End of class

extension CreateBCViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage = UIImage()
        if let img = info[.editedImage] as? UIImage {
            selectedImage = img
        } else if let img = info[.originalImage] as? UIImage {
            selectedImage = img
        }
        
        selectProfileImage.setTitle("", for: .normal)
        imageOfBookClub.image = selectedImage
        imageOfBookClub.layer.cornerRadius = imageOfBookClub.frame.height / 2
        imageOfBookClub.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
} //End of extension

extension CreateBCViewController: PopUpBookSearchDelegate {
    func didSelectBook(book: Book) {
        currentlyReadingBook = book
    }
} //End of extension

extension CreateBCViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing( _ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing( _ textField: UITextField) {
        self.activeTextField = nil
    }
} //End of extension

extension CreateBCViewController: ReloadBCChainDelegate {
    func callDelegateFunc() {
        self.reloadBCDelegate?.reloadUserBookclubs()
    }
} //End of extension
