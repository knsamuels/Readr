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
    @IBOutlet weak var bookClubImage1: UIImageView!
    @IBOutlet weak var bookcluName1: UILabel!
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
                    self.updateViews()
                case .failure(_):
                    print("failed getting user's favorite books")
                }
            }
        }
    }


func updateViews() {
    DispatchQueue.main.async {
        self.favBookPic1.image = self.userFavBooks[0].coverImage
        self.favBookPic2.image = self.userFavBooks[1].coverImage
        self.favBookPic3.image = self.userFavBooks[2].coverImage
        self.titleLabel1.text = self.userFavBooks[0].title
        self.titleLabel2.text = self.userFavBooks[1].title
        self.titleLabel3.text = self.userFavBooks[2].title
        self.authorLabel1.text = self.userFavBooks[0].authors?.first
        self.authorLabel2.text = self.userFavBooks[1].authors?.first
        self.authorLabel3.text = self.userFavBooks[2].authors?.first
        self.bioLabel.text = UserController.shared.currentUser?.bio
    }
}


//        BookController.fetchOneBookWith(ISBN: UserController.shared.currentUser?.favoriteBooks[0] ?? "9780007158447") { (result) in
//            switch result {
//            case .success(let book):
//                self.book1 = book
//                self.fetchBookImage()
//            case .failure(_):
//                print("anything here")
//            }
//        }
//        BookController.fetchOneBookWith(ISBN: UserController.shared.currentUser?.favoriteBooks[1] ?? "9780007158447") { (result) in
//            switch result {
//            case .success(let book):
//                self.book2 = book
//            case .failure(_):
//                print("anything here")
//            }
//        }
//        BookController.fetchOneBookWith(ISBN: UserController.shared.currentUser?.favoriteBooks[2] ?? "9780007158447") { (result) in
//            switch result {
//            case .success(let book):
//                self.book3 = book
//            case .failure(_):
//                print("anything here")
//            }
//        }
//    }
//
//        BookController.fetchImage(book: book2ImageLinks) { (result) in
//            switch result {
//            case .success(let image):
//                self.book2Image = image
//            case .failure(_):
//                print("anything here")
//            }
//        }
//        BookController.fetchImage(book: book3ImageLinks) { (result) in
//            switch result {
//            case .success(let image):
//                self.book3Image = image
//            case .failure(_):
//                print("anything here")
//            }
//        }
//func fetchBookImage() {
//        guard let book1ImageLinks = book1?.imageLinks else {return}
////        guard let book2ImageLinks = book2?.imageLinks else {return}
////        guard let book3ImageLinks = book3?.imageLinks else {return}
//        BookController.fetchImage(book: book1ImageLinks) { (result) in
//            switch result {
//            case .success(let image):
//                self.book1Image = image
//                self.updateViews()
//            case .failure(_):
//                print("anything here")
//            }
//        }
//    }



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

}
