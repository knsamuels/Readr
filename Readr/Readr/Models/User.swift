//
//  User.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import UIKit

class User {
    var username: String
    var firstName: String
    var lastName: String
    var password: String
    var profilePhoto: UIImage?
    var bio: String?
    var favoriteBooks: [String]
    var bookclub: [Bookclub]
    var friendList: [User]
    var followerList: [User]
    var favoriteGenres: [String]
    var bookshelves: [Bookshelf]
    
    
    init(username:String, firstName: String, lastName: String, password: String, image: UIImage, bio: String, favoriteBooks: [String] = [], bookclub: [Bookclub] = [], friendList: [User] = [], followerList: [User] = [], favoriteGenres: [String], bookshelves: [Bookshelf] = []) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.profilePhoto = image
        self.bio = bio
        self.favoriteBooks = favoriteBooks
        self.bookclub = bookclub
        self.friendList = friendList
        self.followerList = followerList
        self.favoriteGenres = favoriteGenres
        self.bookshelves = bookshelves
    }
}
