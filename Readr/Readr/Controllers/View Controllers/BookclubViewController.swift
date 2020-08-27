//
//  BookclubViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

class BookclubViewController: UIViewController {
    
    var bookclub: Bookclub? 
    var currentlyReading: Book?
    var pastReads: [Book] = []
    
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var descriptionOfBookClub: UILabel!
    @IBOutlet weak var meetingInfoForBookClub: UILabel!
    @IBOutlet weak var ImageForCurrentlyReading: UIImageView!
    @IBOutlet weak var titleForCurrentlyReading: UILabel!
    @IBOutlet weak var authorForCurrentlyReading: UILabel!
    @IBOutlet weak var ratingForCurrentlyReading: UILabel!
    @IBOutlet weak var image1ForPastReads: UIImageView!
    @IBOutlet weak var title1ForPastReads: UILabel!
    @IBOutlet weak var author1ForPastReads: UILabel!
    @IBOutlet weak var rating1ForPastReads: UILabel!
    @IBOutlet weak var image2ForPastReads: UIImageView!
    @IBOutlet weak var title2ForPastReads: UILabel!
    @IBOutlet weak var author2ForPastReads: UILabel!
    @IBOutlet weak var rating2ForPastReads: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminContactInfoLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var image3ForPastReads: UIImageView!
    @IBOutlet weak var title3ForPastReads: UILabel!
    @IBOutlet weak var author3ForPastReads: UILabel!
    @IBOutlet weak var rating3ForPastReads: UILabel!
    
    private lazy var loadingScreen: RLogoLoadingView = {
        let view = RLogoLoadingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingScreen()
        loadDataForUser()
        self.title = bookclub?.name
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
//        CreateBCViewController.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadDataForUser()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = bookclub else {return}
        let userAppleRef = user.appleUserRef
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        if userAppleRef != bookclub.admin {
            if bookclub.members.contains(userReference) {
                guard let index = bookclub.members.firstIndex(of: userReference) else {return}
                
                bookclub.members.remove(at: index)
                joinButton.setTitle("Join", for: .normal)
                
            } else {
                user.bookclubs.append(bookclub)
                bookclub.members.append(userReference)
                joinButton.setTitle("Leave", for: .normal)
            }
        }
        BookclubController.shared.update(bookclub: bookclub) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("yes")
                case .failure(_):
                    print("no")
                }
            }
        }
    }
    
    @IBAction func optionButtonTapped(_ sender: UIBarButtonItem) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = self.bookclub else {return}
        let userAppleRef = user.appleUserRef
        if bookclub.admin == userAppleRef {
            presentEditAlert(bookclub: bookclub)
        } else {
            presentShareAlert(bookclub: bookclub)
        }
    }
    
    //MARK: - Helper functions
    
    private func showLoadingScreen() {
        view.addSubview(loadingScreen)
        NSLayoutConstraint.activate([
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateViews(admin: User) {
        DispatchQueue.main.async {
            guard let user = UserController.shared.currentUser else {return}
            guard let bookclub = self.bookclub else {return}
            guard let currentlyReading = self.currentlyReading else {return}
            let userReference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
            let userAppleRef = user.appleUserRef
            
            self.title = bookclub.name
            self.imageOfBookClub.image = bookclub.profilePicture
            self.descriptionOfBookClub.text = bookclub.description
            self.meetingInfoForBookClub.text = bookclub.meetingInfo
            self.adminNameLabel.text = admin.username
            self.adminContactInfoLabel.text = bookclub.adminContactInfo
            
            if bookclub.members.contains(userReference) {
                if bookclub.admin == userAppleRef {
                    self.joinButton.setTitle("Host", for: .normal)
                } else  {
                    self.joinButton.setTitle("Leave", for: .normal)
                }
            } else {
                if bookclub.members.count == bookclub.memberCapacity {
                    self.joinButton.setTitle("Full", for: .normal)
                    self.joinButton.isEnabled = false
                } else {
                    self.joinButton.setTitle("Join", for: .normal)
                    self.joinButton.isEnabled = true
                }
            }
            self.ImageForCurrentlyReading.image = currentlyReading.coverImage
            self.titleForCurrentlyReading.text = currentlyReading.title
            self.authorForCurrentlyReading.text = currentlyReading.authors?.first
            self.ratingForCurrentlyReading.text = "\(currentlyReading.averageRating ?? 0.0)"
            
            let pastReadCount = bookclub.pastReads.count
            switch pastReadCount {
            case 0:
                self.image1ForPastReads.isHidden = true
                self.title1ForPastReads.isHidden = true
                self.author1ForPastReads.isHidden = true
                self.rating1ForPastReads.isHidden = true
                self.image2ForPastReads.isHidden = true
                self.title2ForPastReads.isHidden = true
                self.author2ForPastReads.isHidden = true
                self.rating2ForPastReads.isHidden = true
                self.image3ForPastReads.isHidden = true
                self.title3ForPastReads.isHidden = true
                self.author3ForPastReads.isHidden = true
                self.rating3ForPastReads.isHidden = true
            case 1:
                self.image1ForPastReads.isHidden = false
                self.title1ForPastReads.isHidden = false
                self.author1ForPastReads.isHidden = false
                self.rating1ForPastReads.isHidden = false
                self.image2ForPastReads.isHidden = true
                self.title2ForPastReads.isHidden = true
                self.author2ForPastReads.isHidden = true
                self.rating2ForPastReads.isHidden = true
                self.image3ForPastReads.isHidden = true
                self.title3ForPastReads.isHidden = true
                self.author3ForPastReads.isHidden = true
                self.rating3ForPastReads.isHidden = true
            case 2:
                self.image1ForPastReads.isHidden = false
                self.title1ForPastReads.isHidden = false
                self.author1ForPastReads.isHidden = false
                self.rating1ForPastReads.isHidden = false
                self.image2ForPastReads.isHidden = false
                self.title2ForPastReads.isHidden = false
                self.author2ForPastReads.isHidden = false
                self.rating2ForPastReads.isHidden = false
                self.image3ForPastReads.isHidden = true
                self.title3ForPastReads.isHidden = true
                self.author3ForPastReads.isHidden = true
                self.rating3ForPastReads.isHidden = true
                
            default:
                self.image1ForPastReads.isHidden = false
                self.title1ForPastReads.isHidden = false
                self.author1ForPastReads.isHidden = false
                self.rating1ForPastReads.isHidden = false
                self.image2ForPastReads.isHidden = false
                self.title2ForPastReads.isHidden = false
                self.author2ForPastReads.isHidden = false
                self.rating2ForPastReads.isHidden = false
                self.image3ForPastReads.isHidden = false
                self.title3ForPastReads.isHidden = false
                self.author3ForPastReads.isHidden = false
                self.rating3ForPastReads.isHidden = false
            }
        }
    }
    
    private func loadDataForUser() {
        guard let adminReference = bookclub?.admin else {return}
        UserController.shared.fetchUser(withReference: adminReference) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let admin):
                    self.fetchBook() {
                        self.updateViews(admin: admin)
                        self.loadingScreen.removeFromSuperview()
                        //fetchPastReads --- need to add call updateViews in PastReads closure
                    }
                case .failure(_):
                    print("there was an error fetching the user")
                }
            }
        }
    }
    func fetchBook(completion: @escaping() -> Void) {
        guard let bookclub = bookclub else { return}
        BookController.fetchOneBookWith(ISBN: bookclub.currentlyReading) {
            (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let book):
                    self.currentlyReading = book
                    completion()
                case .failure(_):
                    completion()
                    print("error fetching book")
                }
            }
        }
    }

    func presentShare(bookclub: Bookclub) {
        let title = " Please open Readen, search \(bookclub.name) under clubs tab and join this bookclub!"
        let shareSheet = UIActivityViewController(activityItems: [title], applicationActivities: nil)
        
        self.present(shareSheet, animated: true, completion: nil)
    }
   
    func presentEditAlert(bookclub: Bookclub?) {
        guard let bookclub = bookclub else {return}
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            self.presentShare(bookclub: bookclub)
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            guard let createVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "toCreateBCVC") as? CreateBCViewController else {return}
            createVC.modalPresentationStyle = .fullScreen
            createVC.bookclub = bookclub
            self.present(createVC, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete Bookclub", style: .default) { (_) in
            BookclubController.shared.delete(bookclub: bookclub) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(_):
                        print("could not delete bookclub")
                    }
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(shareAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentShareAlert(bookclub: Bookclub?) {
        guard let bookclub = bookclub else {return}
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            
            let shareSheet = UIActivityViewController(activityItems: [bookclub], applicationActivities: nil)
            
            self.present(shareSheet, animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(shareAction)
        
        self.present(alertController, animated: true)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bcCurrentlyReadingImageToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = currentlyReading
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage1ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[0]
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage2ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[1]
            destination.book = bookToSend
        } else if segue.identifier == "bcPastReadsImage3ToBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let bookToSend = pastReads[2]
            destination.book = bookToSend
        }
    }
}

extension BookclubViewController: UpdateBookclubDelegate {
    func updateBookclub(for bookclub: Bookclub) {
        self.bookclub = bookclub
        self.loadDataForUser()
    }
}
