//
//  BookclubViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

protocol ReloadBCChainDelegate: AnyObject {
    func callDelegateFunc()
}

class BookclubViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imageOfBookClub: UIImageView!
    @IBOutlet weak var descriptionOfBookClub: UILabel!
    @IBOutlet weak var meetingInfoForBookClub: UILabel!
    @IBOutlet weak var ImageForCurrentlyReading: UIImageView!
    @IBOutlet weak var titleForCurrentlyReading: UILabel!
    @IBOutlet weak var authorForCurrentlyReading: UILabel!
    @IBOutlet weak var ratingForCurrentlyReading: UILabel!
    @IBOutlet weak var image1ForPastReads: UIImageView!
    @IBOutlet weak var title1ForPastReads: UILabel!
    @IBOutlet weak var rating1ForPastReads: UILabel!
    @IBOutlet weak var image2ForPastReads: UIImageView!
    @IBOutlet weak var title2ForPastReads: UILabel!
    @IBOutlet weak var rating2ForPastReads: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminContactInfoLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var image3ForPastReads: UIImageView!
    @IBOutlet weak var title3ForPastReads: UILabel!
    @IBOutlet weak var rating3ForPastReads: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var pastReadsRatingStar1: UIImageView!
    @IBOutlet weak var pastReadsRatingStar2: UIImageView!
    @IBOutlet weak var pastReadsRatingStar3: UIImageView!
    @IBOutlet weak var pastReads1Button: UIButton!
    @IBOutlet weak var pastReads2Button: UIButton!
    @IBOutlet weak var pastReads3Button: UIButton!
    @IBOutlet weak var currentlyReadingLabel: UILabel!
    @IBOutlet weak var currentlyReadingStackView: UIStackView!
    @IBOutlet weak var pastReadsStakView: UIStackView!
    @IBOutlet weak var adminStackView: UIStackView!
    
    //MARK: - Properties
    var bookclub: Bookclub?
    var currentlyReading: Book?
    var pastReads: [Book] = []
    weak var chainDelegate: ReloadBCChainDelegate?
    
    private lazy var loadingScreen: RLogoLoadingView = {
        let view = RLogoLoadingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingScreen()
        loadDataForUser()
        self.title = bookclub?.name
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfUserIsBlocked()
        setUpImage()
        
        chainDelegate?.callDelegateFunc()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("run this shitttt")
    }
    
    @IBAction func unwindToBookclubVC(_ sender: UIStoryboardSegue) {}
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = bookclub else {return}
        let userAppleRef = user.appleUserRef
        //        let userReference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
        if userAppleRef != bookclub.admin {
            if bookclub.members.contains(userAppleRef) {
                guard let index = bookclub.members.firstIndex(of: userAppleRef) else {return}
                bookclub.members.remove(at: index)
                joinButton.setTitle("Join", for: .normal)
                self.joinButton.setTitleColor(.black, for: .normal)
                self.joinButton.backgroundColor = .white
                self.memberCountLabel.text = "\(bookclub.members.count)"
                BookclubController.shared.removeSubscriptionTo(messagesForBookclub: bookclub) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case true:
                            print("Removed subscription")
                        case false:
                            print("Could not remove subscription")
                        }
                    }
                }
            } else {
                user.bookclubs.append(bookclub)
                bookclub.members.append(userAppleRef)
                joinButton.setTitle("Member", for: .normal)
                self.joinButton.setTitleColor(.white, for: .normal)
                self.joinButton.backgroundColor = .accentBlack
                self.memberCountLabel.text = "\(bookclub.members.count)"
                BookclubController.shared.addSubscriptionTo(messagesForBookclub: bookclub) { (result, error) in
                    DispatchQueue.main.async {
                        switch result {
                        case true:
                            print("User is now subscribed to notifications")
                        case false:
                            print("Could not subscribe the user to notifications")
                        }
                    }
                }
            }
            //UserController.shared.updateUser(user: user) { (result) in
            //}
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
    
    @IBAction func viewAllMembersButtonTapped(_ sender: UIButton) {
    }
    
    //MARK: - Helper functions
    
    func setUpImage() {
        imageOfBookClub.layer.cornerRadius = imageOfBookClub.frame.height / 2
        imageOfBookClub.clipsToBounds = true
    }
    
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
            //            let userReference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
            if bookclub.blockedUsers.contains(user.username) {
                self.updateBlockedViews()
            } else {
                let userAppleRef = user.appleUserRef
                self.title = bookclub.name
                //            self.imageOfBookClub.image = bookclub.profilePicture
                if let image1 = bookclub.profilePicture {
                    self.imageOfBookClub.image = image1
                } else {
                    self.imageOfBookClub.image = UIImage(named: "ReadenLogoWhiteSpace")
                }
                self.descriptionOfBookClub.text = bookclub.description
                self.meetingInfoForBookClub.text = "Meets \(bookclub.meetingInfo)"
                self.adminNameLabel.text = "Admin:   \(admin.username)"
                self.memberCountLabel.text = "\(bookclub.members.count)"
                self.adminContactInfoLabel.text = bookclub.adminContactInfo
                
                if bookclub.members.contains(userAppleRef) {
                    self.joinButton.setTitleColor(.white, for: .normal)
                    self.joinButton.backgroundColor = .accentBlack
                    if bookclub.admin == userAppleRef {
                        self.joinButton.setTitle("Host", for: .normal)
                    } else  {
                        self.joinButton.setTitle("Member", for: .normal)
                    }
                } else {
                    self.joinButton.setTitleColor(.black, for: .normal)
                    self.joinButton.backgroundColor = .white
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
                self.ratingForCurrentlyReading.text = " \(currentlyReading.averageRating ?? 0.0)"
                
                self.image1ForPastReads.isHidden = false
                self.title1ForPastReads.isHidden = false
                self.rating1ForPastReads.isHidden = false
                self.pastReads1Button.isHidden = false
                self.image2ForPastReads.isHidden = false
                self.title2ForPastReads.isHidden = false
                self.rating2ForPastReads.isHidden = false
                self.pastReads2Button.isHidden = false
                self.image3ForPastReads.isHidden = false
                self.title3ForPastReads.isHidden = false
                self.rating3ForPastReads.isHidden = false
                self.pastReads3Button.isHidden = false
                self.pastReadsRatingStar1.isHidden = false
                self.pastReadsRatingStar2.isHidden = false
                self.pastReadsRatingStar3.isHidden = false
                
                let pastReadCount = self.pastReads.count
                switch pastReadCount {
                case 0:
                    self.image1ForPastReads.isHidden = true
                    self.title1ForPastReads.isHidden = true
                    self.rating1ForPastReads.isHidden = true
                    self.pastReads1Button.isHidden = true
                    self.image2ForPastReads.isHidden = true
                    self.title2ForPastReads.isHidden = true
                    self.rating2ForPastReads.isHidden = true
                    self.pastReads2Button.isHidden = true
                    self.image3ForPastReads.isHidden = true
                    self.title3ForPastReads.isHidden = true
                    self.rating3ForPastReads.isHidden = true
                    self.pastReads3Button.isHidden = true
                    self.pastReadsRatingStar1.isHidden = true
                    self.pastReadsRatingStar2.isHidden = true
                    self.pastReadsRatingStar3.isHidden = true
                case 1:
                    self.image1ForPastReads.isHidden = false
                    self.title1ForPastReads.isHidden = false
                    self.rating1ForPastReads.isHidden = false
                    self.pastReads1Button.isHidden = false
                    self.image1ForPastReads.image = self.pastReads[0].coverImage
                    self.title1ForPastReads.text = self.pastReads[0].title
                    self.rating1ForPastReads.text = "\(self.pastReads[0].averageRating ?? 0.0)"
                    self.image2ForPastReads.isHidden = true
                    self.title2ForPastReads.isHidden = true
                    self.rating2ForPastReads.isHidden = true
                    self.pastReads2Button.isHidden = true
                    self.image3ForPastReads.isHidden = true
                    self.title3ForPastReads.isHidden = true
                    self.rating3ForPastReads.isHidden = true
                    self.pastReads3Button.isHidden = true
                    self.pastReadsRatingStar1.isHidden = false
                    self.pastReadsRatingStar2.isHidden = true
                    self.pastReadsRatingStar3.isHidden = true
                case 2:
                    self.image1ForPastReads.isHidden = false
                    self.title1ForPastReads.isHidden = false
                    self.rating1ForPastReads.isHidden = false
                    self.pastReads1Button.isHidden = false
                    self.image1ForPastReads.image = self.pastReads[0].coverImage
                    self.title1ForPastReads.text = self.pastReads[0].title
                    self.rating1ForPastReads.text = "\(self.pastReads[0].averageRating ?? 0.0)"
                    self.image2ForPastReads.isHidden = false
                    self.title2ForPastReads.isHidden = false
                    self.rating2ForPastReads.isHidden = false
                    self.pastReads2Button.isHidden = false
                    self.image2ForPastReads.image = self.pastReads[1].coverImage
                    self.title2ForPastReads.text = self.pastReads[1].title
                    self.rating2ForPastReads.text = "\(self.pastReads[1].averageRating ?? 0.0)"
                    self.image3ForPastReads.isHidden = true
                    self.title3ForPastReads.isHidden = true
                    self.rating3ForPastReads.isHidden = true
                    self.pastReads3Button.isHidden = true
                    self.pastReadsRatingStar1.isHidden = false
                    self.pastReadsRatingStar2.isHidden = false
                    self.pastReadsRatingStar3.isHidden = true
                default:
                    self.image1ForPastReads.isHidden = false
                    self.title1ForPastReads.isHidden = false
                    self.rating1ForPastReads.isHidden = false
                    self.pastReads1Button.isHidden = false
                    self.image1ForPastReads.image = self.pastReads[0].coverImage
                    self.title1ForPastReads.text = self.pastReads[0].title
                    self.rating1ForPastReads.text = "\(self.pastReads[0].averageRating ?? 0.0)"
                    self.image2ForPastReads.isHidden = false
                    self.title2ForPastReads.isHidden = false
                    self.rating2ForPastReads.isHidden = false
                    self.pastReads2Button.isHidden = false
                    self.image2ForPastReads.image = self.pastReads[1].coverImage
                    self.title2ForPastReads.text = self.pastReads[1].title
                    self.rating2ForPastReads.text = "\(self.pastReads[1].averageRating ?? 0.0)"
                    self.image3ForPastReads.isHidden = false
                    self.title3ForPastReads.isHidden = false
                    self.rating3ForPastReads.isHidden = false
                    self.pastReads3Button.isHidden = false
                    self.image3ForPastReads.image = self.pastReads[2].coverImage
                    self.title3ForPastReads.text = self.pastReads[2].title
                    self.rating3ForPastReads.text = "\(self.pastReads[2].averageRating ?? 0.0)"
                    self.pastReadsRatingStar1.isHidden = false
                    self.pastReadsRatingStar2.isHidden = false
                    self.pastReadsRatingStar3.isHidden = false
                }
                self.loadingScreen.removeFromSuperview()
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
                        self.fetchPastReads {
                            self.updateViews(admin: admin)
                            //                            self.loadingScreen.removeFromSuperview()
                        }
                        //fetchPastReads --- need to add call updateViews in PastReads closure
                    }
                case .failure(_):
                    print("there was an error fetching the user")
                }
            }
        }
    }
    
    func fetchPastReads(completion: @escaping() -> Void) {
        guard let bookclub = bookclub else {return}
        var tempPastReads: [Book] = []
        let group = DispatchGroup()
        for isbn in bookclub.pastReads {
            group.enter()
            BookController.fetchOneBookWith(ISBN: isbn) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let book):
                        tempPastReads.append(book)
                    case .failure(_):
                        print("error fetching past reads book")
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            let sortedPastReads = tempPastReads.sorted(by: {$0.title < $1.title})
            self.pastReads = sortedPastReads
            completion()
        }
    }
    
    func fetchBook(completion: @escaping() -> Void) {
        guard let bookclub = bookclub else {return}
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(shareAction)
        
        self.present(alertController, animated: true)
    }
    
    func presentShareAlert(bookclub: Bookclub?) {
        guard let bookclub = bookclub else {return}
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let reportAction = UIAlertAction(title: "Report Bookclub", style: .destructive) { (_) in
            let confirmReportController = UIAlertController(title: "Report Bookclub?", message: nil, preferredStyle: .alert)
            let cancelReportAction = UIAlertAction(title: "Cancel", style: .cancel)
            let confirmReportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
                print("report")
            }
            confirmReportController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            confirmReportController.view.tintColor = .accentBlack
            confirmReportController.addAction(cancelReportAction)
            confirmReportController.addAction(confirmReportAction)
            
            self.present(confirmReportController, animated: true)
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            
            let shareSheet = UIActivityViewController(activityItems: [bookclub], applicationActivities: nil)
            
            self.present(shareSheet, animated: true, completion: nil)
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(shareAction)
        alertController.addAction(reportAction)
        
        self.present(alertController, animated: true)
    }
    func checkIfUserIsBlocked() {
        guard let user = UserController.shared.currentUser else {return}
        guard let bookclub = bookclub else {return}
        if bookclub.blockedUsers.contains(user.username) {
            self.loadingScreen.removeFromSuperview()
            updateBlockedViews()
        } else {
            loadDataForUser()
        }
    }
    
    func updateBlockedViews() {
        self.image1ForPastReads.isHidden = true
        self.title1ForPastReads.isHidden = true
        self.rating1ForPastReads.isHidden = true
        self.pastReads1Button.isHidden = true
        self.image2ForPastReads.isHidden = true
        self.title2ForPastReads.isHidden = true
        self.rating2ForPastReads.isHidden = true
        self.pastReads2Button.isHidden = true
        self.image3ForPastReads.isHidden = true
        self.title3ForPastReads.isHidden = true
        self.rating3ForPastReads.isHidden = true
        self.pastReads3Button.isHidden = true
        self.pastReadsRatingStar1.isHidden = true
        self.pastReadsRatingStar2.isHidden = true
        self.pastReadsRatingStar3.isHidden = true
        self.descriptionOfBookClub.isHidden = true
        self.meetingInfoForBookClub.isHidden = true
        self.currentlyReadingLabel.isHidden = true
        self.currentlyReadingStackView.isHidden = true
        self.adminStackView.isHidden = true
        self.pastReadsStakView.isHidden = true
        self.joinButton.isHidden = true
        self.imageOfBookClub.image = UIImage(named: "RLogoGray")
        self.memberCountLabel.text = "0"
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
        } else if segue.identifier == "toMemberListVC" {
            guard let destination = segue.destination as?
                MemberListTableViewController else {return}
            let bookclubToSend = bookclub
            destination.bookclub = bookclubToSend
        }
        else if segue.identifier == "bcPastReadsViewAllToPRLTVC" {
            guard let bookclub = bookclub else {return}
            guard let destination = segue.destination as? PastReadsListTableViewController else {return}
            let booksToSend = pastReads
            destination.books = booksToSend
            destination.bookclub = bookclub
        }
    }
}

