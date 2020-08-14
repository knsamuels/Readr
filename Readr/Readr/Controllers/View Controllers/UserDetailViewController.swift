//
//  UserDetailViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: Properties:
    var userFavBooks: [Book] = []
    var userBookClubs: [Bookclub] = []
    
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
    @IBOutlet weak var favBookPic4: UIImageView!
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var authorLabel4: UILabel!
    @IBOutlet weak var favGenreName1: UILabel!
    @IBOutlet weak var favGenrePic1: UIImageView!
    @IBOutlet weak var favGenrePic2: UIImageView!
    @IBOutlet weak var favGenreName2: UILabel!
    @IBOutlet weak var favGenrePic3: UIImageView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        createUser()
        fetchUser()
    }
    
    //helper functions
    
    func createUser() {
        UserController.shared.createUser(username: "ksam17", firstName: "Kristin", lastName: "Samuels", favoriteAuthor: "Stephen King") { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
            case .failure(_):
                print("we did not create a new user")
            }
        }
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (result) in
            switch result {
            case .success(let user):
                UserController.shared.currentUser = user
                print("we fetched a user")
                self.fetchUserBooks()
            case .failure(_):
                print("We did not get a user")
            }
        }
    }
    
    func fetchUserBooks() {
        guard let user = UserController.shared.currentUser else {return}
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
            self.title = UserController.shared.currentUser?.username
            self.bioLabel.text = UserController.shared.currentUser?.bio
            let numberOfBooks = self.userFavBooks.count
            switch numberOfBooks {
            case 0:
                self.favBookPic1.isHidden = true
                self.titleLabel1.isHidden = true
                self.authorLabel1.isHidden = true
                self.favBookPic2.isHidden = true
                self.titleLabel2.isHidden = true
                self.authorLabel2.isHidden = true
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBookPic4.isHidden = true
                self.titleLabel4.isHidden = true
                self.authorLabel4.isHidden = true
            case 1:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBookPic2.isHidden = true
                self.titleLabel2.isHidden = true
                self.authorLabel2.isHidden = true
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBookPic4.isHidden = true
                self.titleLabel4.isHidden = true
                self.authorLabel4.isHidden = true
            case 2:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBookPic2.image = self.userFavBooks[1].coverImage
                self.titleLabel2.text = self.userFavBooks[1].title
                self.authorLabel2.text = self.userFavBooks[1].authors?.first
                self.favBookPic3.isHidden = true
                self.titleLabel3.isHidden = true
                self.authorLabel3.isHidden = true
                self.favBookPic4.isHidden = true
                self.titleLabel4.isHidden = true
                self.authorLabel4.isHidden = true
            case 3:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBookPic2.image = self.userFavBooks[1].coverImage
                self.titleLabel2.text = self.userFavBooks[1].title
                self.authorLabel2.text = self.userFavBooks[1].authors?.first
                self.favBookPic3.image = self.userFavBooks[2].coverImage
                self.titleLabel3.text = self.userFavBooks[2].title
                self.authorLabel3.text = self.userFavBooks[2].authors?.first
                self.favBookPic4.isHidden = true
                self.titleLabel4.isHidden = true
                self.authorLabel4.isHidden = true
            default:
                self.favBookPic1.image = self.userFavBooks[0].coverImage
                self.titleLabel1.text = self.userFavBooks[0].title
                self.authorLabel1.text = self.userFavBooks[0].authors?.first
                self.favBookPic2.image = self.userFavBooks[1].coverImage
                self.titleLabel2.text = self.userFavBooks[1].title
                self.authorLabel2.text = self.userFavBooks[1].authors?.first
                self.favBookPic3.image = self.userFavBooks[2].coverImage
                self.titleLabel3.text = self.userFavBooks[2].title
                self.authorLabel3.text = self.userFavBooks[2].authors?.first
                self.favBookPic4.image = self.userFavBooks[3].coverImage
                self.titleLabel4.text = self.userFavBooks[3].title
                self.authorLabel4.text = self.userFavBooks[3].authors?.first
            }
            let numberOfGenres = UserController.shared.currentUser?.favoriteGenres.count
            switch numberOfGenres {
            case 0:
                self.favGenrePic1.isHidden = true
                self.favGenreName1.isHidden = true
                self.favGenrePic2.isHidden = true
                self.favGenreName2.isHidden = true
                self.favGenrePic3.isHidden = true
                self.favGenreName3.isHidden = true
            case 1:
                self.favGenrePic1.isHidden = true
                self.favGenreName1.text = UserController.shared.currentUser?.favoriteGenres[0]
                self.favGenrePic2.isHidden = true
                self.favGenreName2.isHidden = true
                self.favGenrePic3.isHidden = true
                self.favGenreName3.isHidden = true
            case 2:
                self.favGenrePic1.isHidden = true
                self.favGenreName1.text = UserController.shared.currentUser?.favoriteGenres[0]
                self.favGenrePic2.isHidden = true
                self.favGenreName2.text = UserController.shared.currentUser?.favoriteGenres[1]
                self.favGenrePic3.isHidden = true
                self.favGenreName3.isHidden = true
            default:
                self.favGenrePic1.isHidden = true
                self.favGenreName1.text = UserController.shared.currentUser?.favoriteGenres[0]
                self.favGenrePic2.isHidden = true
                self.favGenreName2.text = UserController.shared.currentUser?.favoriteGenres[1]
                self.favGenrePic3.isHidden = true
                self.favGenreName3.text = UserController.shared.currentUser?.favoriteGenres[2]
            }
            
            let numberOfBookClubs = self.userBookClubs.count
            switch numberOfBookClubs {
            case 0:
                self.bookclubImage1.isHidden = true
                self.bookclubName1.isHidden = true
                self.bookclubImage2.isHidden = true
                self.bookclubName2.isHidden = true
                self.bookclubImage3.isHidden = true
                self.bookclubName3.isHidden = true
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
            case 1:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclubImage2.isHidden = true
                self.bookclubName2.isHidden = true
                self.bookclubImage3.isHidden = true
                self.bookclubName3.isHidden = true
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
            case 2:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclubImage3.isHidden = true
                self.bookclubName3.isHidden = true
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
            case 3:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                self.bookclubName3.text = self.userBookClubs[2].name
                self.bookclubImage4.isHidden = true
                self.bookclubName4.isHidden = true
            default:
                self.bookclubImage1.image = self.userBookClubs[0].profilePicture
                self.bookclubName1.text = self.userBookClubs[0].name
                self.bookclubImage2.image = self.userBookClubs[1].profilePicture
                self.bookclubName2.text = self.userBookClubs[1].name
                self.bookclubImage3.image = self.userBookClubs[2].profilePicture
                self.bookclubName3.text = self.userBookClubs[2].name
                self.bookclubImage4.image = self.userBookClubs[3].profilePicture
                self.bookclubName4.text = self.userBookClubs[3].name
            }
           
        }
    }
    func getUsersBookclubs() {
        guard let user = UserController.shared.currentUser else {return}
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
