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
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingScreen()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        print("The view appeared")
//        userFavBooks = []
        favBookISBNs = []
        if self.user == nil {
                   fetchUser()
               } else {
                   fetchUserBooks()
               }
    }
    //MARK: - Helper Methods
    
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
                    self.userFavBooks = books
                    self.getUsersBookclubs()
                case .failure(_):
                    print("failed getting user's favorite books")
                }
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = self.user else {return}
            if user == UserController.shared.currentUser {
                self.selectProfileImage.isHidden = false
            } else {
                self.selectProfileImage.isHidden = true
            }
            if let image = self.user?.profilePhoto {
                self.selectProfileImage.setTitle("Edit Photo", for: .normal)
                self.profilePic.image = image
            } else {
                self.profilePic.image = self.user?.profilePhoto ?? UIImage(named: "ReadenLogo")
            }
            self.favBookPic1.isHidden = false
            self.titleLabel1.isHidden = false
            self.authorLabel1.isHidden = false
            self.favBook1ButtonLabel.isHidden = false
            self.favBookPic2.isHidden = false
            self.titleLabel2.isHidden = false
            self.authorLabel2.isHidden = false
            self.favBook2ButtonLabel.isHidden = false
            self.favBookPic3.isHidden = false
            self.titleLabel3.isHidden = false
            self.authorLabel3.isHidden = false
            self.favBook3ButtonLabel.isHidden = false
            self.title = self.user?.username ?? "N/A"
            self.bioLabel.text = self.user?.bio ?? "N/A"
            let numberOfBooks = self.userFavBooks.count
            switch numberOfBooks {
            case 0:
                self.favBookPic1.isHidden = true
                self.titleLabel1.isHidden = true
                self.authorLabel1.isHidden = true
                self.favBook1ButtonLabel.isHidden = true
                self.favBookPic2.isHidden = true
                self.titleLabel2.isHidden = true
                self.authorLabel2.isHidden = true
                self.favBook2ButtonLabel.isHidden = true
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBook3ButtonLabel.isHidden = true
                
            case 1:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBook1ButtonLabel.isHidden = false
                self.favBookPic2.isHidden = true
                self.titleLabel2.isHidden = true
                self.authorLabel2.isHidden = true
                self.favBook2ButtonLabel.isHidden = true
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBook3ButtonLabel.isHidden = true
            case 2:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBook1ButtonLabel.isHidden = false
                self.favBookPic2.image = self.userFavBooks[1].coverImage
                self.titleLabel2.text = self.userFavBooks[1].title
                self.authorLabel2.text = self.userFavBooks[1].authors?.first
                self.favBook2ButtonLabel.isHidden = false
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBook3ButtonLabel.isHidden = true
            default:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBook1ButtonLabel.isHidden = false
                self.favBookPic2.image = self.userFavBooks[1].coverImage
                self.titleLabel2.text = self.userFavBooks[1].title
                self.authorLabel2.text = self.userFavBooks[1].authors?.first
                self.favBook2ButtonLabel.isHidden = false
                self.favBookPic3.image = self.userFavBooks[2].coverImage
                self.titleLabel3.text = self.userFavBooks[2].title
                self.authorLabel3.text = self.userFavBooks[2].authors?.first
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
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
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
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclub1ButtonLabel.isHidden = false
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclub2ButtonLabel.isHidden = false
                self.bookclubImage3.isHidden = true
                self.bookclubName3.isHidden = true
                self.bookclub3ButtonLabel.isHidden = true
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
                self.bookclub4ButtonLabel.isHidden = true
            case 3:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclub1ButtonLabel.isHidden = false
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclub2ButtonLabel.isHidden = false
                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                self.bookclubName3.text = self.userBookClubs[2].name
                self.bookclub3ButtonLabel.isHidden = false
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
                self.bookclub4ButtonLabel.isHidden = true
            default:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclub1ButtonLabel.isHidden = false
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclub2ButtonLabel.isHidden = false
                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                self.bookclubName3.text = self.userBookClubs[2].name
                self.bookclub3ButtonLabel.isHidden = false
                self.bookclubImage4.image = self.userBookClubs[3].profilePicture
                self.bookclubName4.text = self.userBookClubs[3].name
                self.bookclub4ButtonLabel.isHidden = false
            }
            self.loadingScreen.removeFromSuperview()
        }
    }
    
    func getUsersBookclubs() {
        guard let user = self.user else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            switch result {
            case .success(let bookclubs):
                self.userBookClubs = bookclubs
                self.updateViews()
            case .failure(_):
                print("we could not get the user's bookclubs")
            }
        }
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
        } else if segue.identifier == "userBookclub1ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let favBookclubToSend = userBookClubs[0]
            destination.bookclub = favBookclubToSend
        } else if segue.identifier == "userBookclub2ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let favBookclubToSend = userBookClubs[1]
            destination.bookclub = favBookclubToSend
        } else if segue.identifier == "userBookclub3ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let favBookclubToSend = userBookClubs[2]
            destination.bookclub = favBookclubToSend
        } else if segue.identifier == "userBookclub4ToBookClubVC" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let favBookclubToSend = userBookClubs[3]
            destination.bookclub = favBookclubToSend
        }
    }
}

extension UserDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
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
