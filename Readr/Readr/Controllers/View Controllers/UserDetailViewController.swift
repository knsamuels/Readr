//
//  UserDetailViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties:
    var userFavBooks: [Book] = []
    var userBookClubs: [Bookclub] = []
    var favBookISBNs: [String] = []
    var user: User?
    
    private lazy var loadingScreen: RLogoLoadingView = {
        let view = RLogoLoadingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Outlets
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var favBookPic1: UIImageView!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var authorLabel1: UILabel!
    @IBOutlet weak var favBookPic2: UIImageView!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var authorLabel2: UILabel!
    @IBOutlet weak var favBookPic3: UIImageView!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var authorLabel3: UILabel!
    @IBOutlet weak var favGenreName1: UILabel!
    @IBOutlet weak var favGenreName2: UILabel!
    @IBOutlet weak var favGenreName3: UILabel!
    @IBOutlet weak var bookclubImage1: UIImageView!
    @IBOutlet weak var bookclubName1: UILabel!
    @IBOutlet weak var bookclubName2: UILabel!
    @IBOutlet weak var bookclubImage2: UIImageView!
    @IBOutlet weak var bookclubImage3: UIImageView!
    @IBOutlet weak var bookclubName3: UILabel!
    @IBOutlet weak var bookclubImage4: UIImageView!
    @IBOutlet weak var bookclubName4: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var favBook1ButtonLabel: UIButton!
    @IBOutlet weak var favBook2ButtonLabel: UIButton!
    @IBOutlet weak var favBook3ButtonLabel: UIButton!
    @IBOutlet weak var bookclub1ButtonLabel: UIButton!
    @IBOutlet weak var bookclub2ButtonLabel: UIButton!
    @IBOutlet weak var bookclub3ButtonLabel: UIButton!
    @IBOutlet weak var bookclub4ButtonLabel: UIButton!
    @IBOutlet weak var selectProfileImage: UIButton!
    @IBOutlet weak var createBookclubButton: UIButton!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var optionButton: UIBarButtonItem!
    @IBOutlet weak var favoriteBooksLabel: UILabel!
    @IBOutlet weak var favoriteGenresLabel: UILabel!
    @IBOutlet weak var bookclubLabelStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingScreen()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBookclubs), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        setUpImage()
        updateViews()
        favBookISBNs = []
        if self.user == nil || self.user == UserController.shared.currentUser {
            fetchUser()
        } else {
            checkIfUserIsBlocked()
        }
        guard let user = user else {return}
        print("FOLLOWING: \(user.followingList.count)")
        print("FOLLOWERS: \(user.followerList.count)")
    }
    
    //MARK: - Actions
    @IBAction func unwindToUserDetail(_ sender: UIStoryboardSegue) {}
    
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
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let user = user else {return}
        guard let currentUser = UserController.shared.currentUser else {return}
        
        if user.followerList.contains(currentUser.username) {
            guard let followerIndex = user.followerList.firstIndex(of: currentUser.username) else {return}
            user.followerList.remove(at: followerIndex)
            guard let followingIndex = currentUser.followingList.firstIndex(of: user.username) else {return}
            currentUser.followingList.remove(at: followingIndex)
        } else {
            user.followerList.append(currentUser.username)
            currentUser.followingList.append(user.username)
        }
        UserController.shared.updateUser(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.updateViews()
                case .failure(_):
                    print("Could not update user with followers")
                }
            }
        }
        UserController.shared.updateUser(user: currentUser) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.updateViews()
                case .failure(_):
                    print("Could not update user with followers")
                }
            }
        }
    }
    
    @IBAction func optionButtonTapped(_ sender: Any) {
        presentOptionAlert()
    }
    
    //MARK: - Helper Methods
    func setUpImage() {
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.clipsToBounds = true
        
        bookclubImage1.layer.cornerRadius = bookclubImage1.frame.width / 2
        bookclubImage1.clipsToBounds = true
        bookclubImage2.layer.cornerRadius = bookclubImage2.frame.height / 2
        bookclubImage2.clipsToBounds = true
        bookclubImage3.layer.cornerRadius = bookclubImage3.frame.height / 2
        bookclubImage3.clipsToBounds = true
        bookclubImage4.layer.cornerRadius = bookclubImage4.frame.height / 2
        bookclubImage4.clipsToBounds = true
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
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
            switch result {
            case .success(let user):
                self.user = user
                print("we fetched a user")
                self.fetchUserBooks()
            case .failure(_):
                print("We did not get a user")
            }
        }
    }
    
    func fetchUserBooks() {
        guard let user = self.user else {return}
        BookshelfController.shared.fetchFavoritesBookshelf(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookshelf):
                    self.retrieveFirstThree(bookshelf: bookshelf)
                case .failure(_):
                    print("Unable to retrieve Favorites")
                }
            }
        }
    }
    
    func retrieveFirstThree(bookshelf: Bookshelf) {
        guard let user = self.user else {return}
        
        let count = bookshelf.books.count
        if count >= 3 {
            for i in 0...2 {
                favBookISBNs.append(bookshelf.books[i])
            }
        }
        else {
            favBookISBNs.append(contentsOf: bookshelf.books)
        }
        user.favoriteBooks = favBookISBNs
        
        BookController.shared.fetchFavoriteBooks(forUser: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    let sortedBooks = books.sorted(by: { $0.title < $1.title })
                    self.userFavBooks = sortedBooks
                    self.getUsersBookclubs()
                case .failure(_):
                    print("failed getting user's favorite books")
                }
            }
        }
        //        self.getUsersBookclubs()
    }
    
    func checkIfUserIsBlocked() {
        guard let user = user else {return}
        guard let currentUser = UserController.shared.currentUser else {return}
        
        if user.blockedUsers.contains(currentUser.username) {
            self.loadingScreen.removeFromSuperview()
            updateBlockedViews()
        } else {
            fetchUserBooks()
        }
    }
    
    func updateBlockedViews() {
        profilePic.image = UIImage(named: "ReadenLogoWhiteSpace")
        followersCountLabel.text = "0"
        followingCountLabel.text = "0"
        self.favBookPic1.isHidden = true
        self.titleLabel1.isHidden = true
        self.favBook1ButtonLabel.isHidden = true
        self.favBookPic2.isHidden = true
        self.titleLabel2.isHidden = true
        self.favBook2ButtonLabel.isHidden = true
        self.favBookPic3.isHidden = true
        self.titleLabel3.isHidden = true
        self.favBook3ButtonLabel.isHidden = true
        self.favGenreName1.isHidden = true
        self.favGenreName2.isHidden = true
        self.favGenreName3.isHidden = true
        self.bookclubImage1.isHidden = true
        self.bookclubName1.isHidden = true
        self.bookclub1ButtonLabel.isHidden = true
        self.bookclubImage2.isHidden = true
        self.bookclubName2.isHidden = true
        self.bookclub2ButtonLabel.isHidden = true
        self.bookclubImage3.isHidden = true
        self.bookclubName3.isHidden = true
        self.bookclub3ButtonLabel.isHidden = true
        self.bookclubImage4.isHidden = true
        self.bookclubName4.isHidden = true
        self.bookclub4ButtonLabel.isHidden = true
        self.bioLabel.isHidden = true
        self.followButton.isHidden = true
        self.optionButton.isEnabled = false
        self.optionButton.tintColor = .clear
        self.favoriteBooksLabel.isHidden = true
        self.favoriteGenresLabel.isHidden = true
        self.bookclubLabelStackView.isHidden = true
        self.selectProfileImage.isHidden = true 
    }
    
    func presentOptionAlert() {
        guard let user = user else {return}
        guard let currentUser = UserController.shared.currentUser else {return}
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let reportAction = UIAlertAction(title: "Report User", style: .destructive) { (_) in
            print("Report")
        }
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
            let confirmBlockController = UIAlertController(title: "Block User?", message: "You will never be able to unblock once you block.", preferredStyle: .alert)
            let cancelBlockAction = UIAlertAction(title: "Cancel", style: .cancel)
            let confirmBlockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
                currentUser.blockedUsers.append(user.username)
                user.blockedUsers.append(currentUser.username)
                if user.followerList.contains(currentUser.username) {
                    guard let index = user.followerList.firstIndex(of: currentUser.username) else {return}
                    user.followerList.remove(at: index)
                }
                if user.followingList.contains(currentUser.username) {
                    guard let index = user.followingList.firstIndex(of: currentUser.username) else {return}
                    user.followingList.remove(at: index)
                }
                if currentUser.followerList.contains(user.username) {
                    guard let index = currentUser.followerList.firstIndex(of: user.username) else {return}
                    currentUser.followerList.remove(at: index)
                }
                if currentUser.followingList.contains(user.username) {
                    guard let index = currentUser.followingList.firstIndex(of: user.username) else {return}
                    currentUser.followingList.remove(at: index)
                }
                UserController.shared.updateUser(user: currentUser) { (result) in
                    switch result {
                    case .success(_):
                        UserController.shared.updateUser(user: user) { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    self.updateBlockedViews()
                                case .failure(_):
                                    print("could not update block lists")
                                }
                            }
                        }
                    case .failure(_):
                        print("could not update block user list")
                    }
                }
            }
            confirmBlockController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            confirmBlockController.view.tintColor = .accentBlack
            confirmBlockController.addAction(cancelBlockAction)
            confirmBlockController.addAction(confirmBlockAction)
            self.present(confirmBlockController, animated: true)
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        alertController.addAction(blockAction)
        
        self.present(alertController, animated: true)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = self.user else {return}
            guard let currentUser = UserController.shared.currentUser else {return}
            if user.blockedUsers.contains(currentUser.username) {
                self.updateBlockedViews()
            } else {
                if user == UserController.shared.currentUser {
                    self.selectProfileImage.isHidden = false
                    self.createBookclubButton.isHidden = false
                    self.followButton.isHidden = true
                    self.optionButton.isEnabled = false
                    self.optionButton.tintColor = .clear
                } else {
                    self.selectProfileImage.isHidden = true
                    self.createBookclubButton.isHidden = true
                    self.followButton.isHidden = false
                    guard let currentUser = UserController.shared.currentUser else {return}
                    if user.followerList.contains(currentUser.username) {
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.setTitleColor(.white, for: .normal)
                        self.followButton.backgroundColor = .accentBlack
                    } else {
                        self.followButton.setTitle("Follow", for: .normal)
                        self.followButton.setTitleColor(.black, for: .normal)
                        self.followButton.backgroundColor = .white
                    }
                }
                if let image = self.user?.profilePhoto {
                    self.selectProfileImage.setTitle("Edit Photo", for: .normal)
                    self.profilePic.image = image
                } else {
                    self.profilePic.image = self.user?.profilePhoto ?? UIImage(named: "ReadenLogoWhiteSpace")
                }
                
                self.followersCountLabel.text = "\(user.followerList.count)"
                self.followingCountLabel.text = "\(user.followingList.count)"
                
                self.favBookPic1.isHidden = false
                self.titleLabel1.isHidden = false
                self.favBook1ButtonLabel.isHidden = false
                self.favBookPic2.isHidden = false
                self.titleLabel2.isHidden = false
                self.favBook2ButtonLabel.isHidden = false
                self.favBookPic3.isHidden = false
                self.titleLabel3.isHidden = false
                self.favBook3ButtonLabel.isHidden = false
                self.title = self.user?.username ?? "N/A"
                self.bioLabel.text = self.user?.bio ?? "N/A"
                let numberOfBooks = self.userFavBooks.count
                switch numberOfBooks {
                case 0:
                    self.favBookPic1.isHidden = true
                    self.titleLabel1.isHidden = true
                    self.favBook1ButtonLabel.isHidden = true
                    self.favBookPic2.isHidden = true
                    self.titleLabel2.isHidden = true
                    self.favBook2ButtonLabel.isHidden = true
                    self.favBookPic3.isHidden = true
                    self.titleLabel3.isHidden = true
                    self.favBook3ButtonLabel.isHidden = true
                    
                case 1:
                    self.favBookPic1.image = self.userFavBooks[0].coverImage
                    self.titleLabel1.text = self.userFavBooks[0].title
                    self.favBook1ButtonLabel.isHidden = false
                    self.favBookPic2.isHidden = true
                    self.titleLabel2.isHidden = true
                    self.favBook2ButtonLabel.isHidden = true
                    self.favBookPic3.isHidden = true
                    self.titleLabel3.isHidden = true
                    self.favBook3ButtonLabel.isHidden = true
                case 2:
                    self.favBookPic1.image = self.userFavBooks[0].coverImage
                    self.titleLabel1.text = self.userFavBooks[0].title
                    self.favBook1ButtonLabel.isHidden = false
                    self.favBookPic2.image = self.userFavBooks[1].coverImage
                    self.titleLabel2.text = self.userFavBooks[1].title
                    self.favBook2ButtonLabel.isHidden = false
                    self.favBookPic3.isHidden = true
                    self.titleLabel3.isHidden = true
                    self.favBook3ButtonLabel.isHidden = true
                default:
                    self.favBookPic1.image = self.userFavBooks[0].coverImage
                    self.titleLabel1.text = self.userFavBooks[0].title
                    self.favBook1ButtonLabel.isHidden = false
                    self.favBookPic2.image = self.userFavBooks[1].coverImage
                    self.titleLabel2.text = self.userFavBooks[1].title
                    self.favBook2ButtonLabel.isHidden = false
                    self.favBookPic3.image = self.userFavBooks[2].coverImage
                    self.titleLabel3.text = self.userFavBooks[2].title
                    self.favBook3ButtonLabel.isHidden = false
                }
                let numberOfGenres = self.user?.favoriteGenres.count ?? 0
                switch numberOfGenres {
                case 0:
                    self.favGenreName1.isHidden = true
                    self.favGenreName2.isHidden = true
                    self.favGenreName3.isHidden = true
                case 1:
                    self.favGenreName1.text = self.user?.favoriteGenres[0]
                    self.favGenreName2.isHidden = true
                    self.favGenreName3.isHidden = true
                case 2:
                    self.favGenreName1.text = self.user?.favoriteGenres[0]
                    self.favGenreName2.text = self.user?.favoriteGenres[1]
                    self.favGenreName3.isHidden = true
                default:
                    self.favGenreName1.text = self.user?.favoriteGenres[0]
                    self.favGenreName2.text = self.user?.favoriteGenres[1]
                    self.favGenreName3.text = self.user?.favoriteGenres[2]
                }
                
                self.bookclubImage1.isHidden = false
                self.bookclubName1.isHidden = false
                self.bookclub1ButtonLabel.isHidden = false
                self.bookclubImage2.isHidden = false
                self.bookclubName2.isHidden = false
                self.bookclub2ButtonLabel.isHidden = false
                self.bookclubImage3.isHidden = false
                self.bookclubName3.isHidden = false
                self.bookclub3ButtonLabel.isHidden = false
                self.bookclubImage4.isHidden = false
                self.bookclubName4.isHidden = false
                self.bookclub4ButtonLabel.isHidden = false
                let numberOfBookClubs = self.userBookClubs.count
                switch numberOfBookClubs {
                case 0:
                    self.bookclubImage1.isHidden = true
                    self.bookclubName1.isHidden = true
                    self.bookclub1ButtonLabel.isHidden = true
                    self.bookclubImage2.isHidden = true
                    self.bookclubName2.isHidden = true
                    self.bookclub2ButtonLabel.isHidden = true
                    self.bookclubImage3.isHidden = true
                    self.bookclubName3.isHidden = true
                    self.bookclub3ButtonLabel.isHidden = true
                    self.bookclubImage4.isHidden = true
                    self.bookclubName4.isHidden = true
                    self.bookclub4ButtonLabel.isHidden = true
                case 1:
                    
                    if let image1 = self.userBookClubs[0].profilePicture {
                        self.bookclubImage1.image = image1
                    } else {
                        self.bookclubImage1.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    
                    //self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                    self.bookclubName1.text = self.userBookClubs[0].name
                    self.bookclub1ButtonLabel.isHidden = false
                    self.bookclubImage2.isHidden = true
                    self.bookclubName2.isHidden = true
                    self.bookclub2ButtonLabel.isHidden = true
                    self.bookclubImage3.isHidden = true
                    self.bookclubName3.isHidden = true
                    self.bookclub3ButtonLabel.isHidden = true
                    self.bookclubImage4.isHidden = true
                    self.bookclubName4.isHidden = true
                    self.bookclub4ButtonLabel.isHidden = true
                case 2:
                    if let image1 = self.userBookClubs[0].profilePicture {
                        self.bookclubImage1.image = image1
                    } else {
                        self.bookclubImage1.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                    self.bookclubName1.text = self.userBookClubs[0].name
                    self.bookclub1ButtonLabel.isHidden = false
                    
                    if let image2 = self.userBookClubs[1].profilePicture {
                        self.bookclubImage2.image = image2
                    } else {
                        self.bookclubImage2.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                    self.bookclubName2.text = self.userBookClubs[1].name
                    self.bookclub2ButtonLabel.isHidden = false
                    self.bookclubImage3.isHidden = true
                    self.bookclubName3.isHidden = true
                    self.bookclub3ButtonLabel.isHidden = true
                    self.bookclubImage4.isHidden = true
                    self.bookclubName4.isHidden = true
                    self.bookclub4ButtonLabel.isHidden = true
                case 3:
                    if let image1 = self.userBookClubs[0].profilePicture {
                        self.bookclubImage1.image = image1
                    } else {
                        self.bookclubImage1.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                    self.bookclubName1.text = self.userBookClubs[0].name
                    self.bookclub1ButtonLabel.isHidden = false
                    if let image2 = self.userBookClubs[1].profilePicture {
                        self.bookclubImage2.image = image2
                    } else {
                        self.bookclubImage1.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                    self.bookclubName2.text = self.userBookClubs[1].name
                    self.bookclub2ButtonLabel.isHidden = false
                    if let image3 = self.userBookClubs[2].profilePicture {
                        self.bookclubImage3.image = image3
                    } else {
                        self.bookclubImage3.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                    self.bookclubName3.text = self.userBookClubs[2].name
                    self.bookclub3ButtonLabel.isHidden = false
                    self.bookclubImage4.isHidden = true
                    self.bookclubName4.isHidden = true
                    self.bookclub4ButtonLabel.isHidden = true
                default:
                    if let image1 = self.userBookClubs[0].profilePicture {
                        self.bookclubImage1.image = image1
                    } else {
                        self.bookclubImage1.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                    self.bookclubName1.text = self.userBookClubs[0].name
                    self.bookclub1ButtonLabel.isHidden = false
                    if let image2 = self.userBookClubs[1].profilePicture {
                        self.bookclubImage2.image = image2
                    } else {
                        self.bookclubImage2.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                    self.bookclubName2.text = self.userBookClubs[1].name
                    self.bookclub2ButtonLabel.isHidden = false
                    if let image3 = self.userBookClubs[2].profilePicture {
                        self.bookclubImage3.image = image3
                    } else {
                        self.bookclubImage3.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                    self.bookclubName3.text = self.userBookClubs[2].name
                    self.bookclub3ButtonLabel.isHidden = false
                    if let image4 = self.userBookClubs[3].profilePicture {
                        self.bookclubImage4.image = image4
                    } else {
                        self.bookclubImage4.image = UIImage(named: "ReadenLogoWhiteSpace")
                    }
                    //                self.bookclubImage4.image = self.userBookClubs[3].profilePicture
                    self.bookclubName4.text = self.userBookClubs[3].name
                    self.bookclub4ButtonLabel.isHidden = false
                }
                self.loadingScreen.removeFromSuperview()
            }
        }
    }
    @objc func getUsersBookclubs() {
        guard let user = self.user else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            switch result {
            case .success(let bookclubs):
                self.userBookClubs = bookclubs.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                self.updateViews()
            case .failure(_):
                print("we could not get the user's bookclubs")
            }
        }
    }
    
    @objc func updateBookclubs() {
        Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(getUsersBookclubs), userInfo:nil, repeats: false)
//        sleep(5)
//        getUsersBookclubs()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bioFavBook1toBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let favBookToSend = userFavBooks[0]
            destination.book = favBookToSend
        } else if segue.identifier == "bioFavBook2toBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let favBookToSend = userFavBooks[1]
            destination.book = favBookToSend
        } else if segue.identifier == "bioFavBook3toBDVC" {
            guard let destination = segue.destination as? BookDetailViewController else {return}
            let favBookToSend = userFavBooks[2]
            destination.book = favBookToSend
        } else if segue.identifier == "UserDetailBC1ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = userBookClubs[0]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "UserDetailBC2ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = userBookClubs[1]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "UserDetailBC3ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = userBookClubs[2]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "UserDetailBC4ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = userBookClubs[3]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "viewAllToBCList" {
            guard let destination = segue.destination as?
                BookclubListTableViewController else {return}
            guard let user = user else {return}
            destination.user = user
        } else if segue.identifier == "followingToFollowList" {
            guard let destination = segue.destination as?
                FollowViewController else {return}
            destination.isFirstSegment = true
            destination.user = user
        } else if segue.identifier == "followersToFollowList" {
            guard let destination = segue.destination as?
                FollowViewController else {return}
            destination.isFirstSegment = false
            destination.user = user
        } else if segue.identifier == "userToCreateBCVC" {
            guard let destination = segue.destination as?
                CreateBCViewController else {return}
            destination.reloadBCDelegate = self
        }
    }
} //End of class

extension UserDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage = UIImage()
        if let img = info[.editedImage] as? UIImage {
            selectedImage = img
        } else if let img = info[.originalImage] as? UIImage {
            selectedImage = img
        }
        
        selectProfileImage.setTitle("Edit Photo", for: .normal)
        profilePic.image = selectedImage
        dismiss(animated: true, completion: nil)
        guard let user = user else {return}
        user.profilePhoto = selectedImage
        UserController.shared.updateUser(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("updated user's image")
                case .failure(_):
                    print("did not update user's image")
                }
            }
        }
    }
} //End of extension

extension UserDetailViewController: ReloadBookclubsDelegate {
    func reloadUserBookclubs() {
        self.updateBookclubs()
    }
} //End of extension
