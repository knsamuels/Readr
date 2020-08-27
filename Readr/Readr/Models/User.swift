//
//  User.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

struct UserStrings {
    static let recordTypeKey = "User"
    static let usernameKey = "username"
    fileprivate static let firstNameKey = "firstName"
    fileprivate static let lastNameKey = "lastName" 
    fileprivate static let bioKey = "bio"
    fileprivate static let favoriteAuthorKey = "favoriteAuthor"
    fileprivate static let favoriteBooksKey = "favoriteBooks"
    fileprivate static let bookclubKey = "bookClub"
    fileprivate static let friendListKey = "friendList"
    fileprivate static let followerListKey = "followerList"
    fileprivate static let blockedUsersKey = "blockedUsers"
    fileprivate static let favoriteGenresKey = "favoriteGenres"
    fileprivate static let bookshelvesKey = "Bookshelf"
    static let appleUserRefKey = "appleUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}

class User {
    var username: String
    var firstName: String
    var lastName: String
    var bio: String
    var favoriteAuthor: String
    var favoriteBooks: [String]
    var bookclubs: [Bookclub]
    var friendList: [String]
    var followerList: [String]
    var blockedUsers: [String]
    var favoriteGenres: [String]
    var bookshelves: [Bookshelf]
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    var photoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let finalURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(".jpg")
            
            do {
                guard let data = photoData else {return nil}
                try data.write(to: finalURL)
                return CKAsset(fileURL: finalURL)
            } catch {
                print("Error writing photo data to a URL - \(error) - \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    init(username: String, firstName: String, lastName: String, bio: String = "", favoriteAuthor: String = "", favoriteBooks: [String] = [], bookclubs: [Bookclub] = [], friendList: [String] = [], followerList: [String] = [], blockedUsers: [String] = [], favoriteGenres: [String] = [], bookshelves: [Bookshelf] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.favoriteAuthor = favoriteAuthor
        self.favoriteBooks = favoriteBooks
        self.bookclubs = bookclubs
        self.friendList = friendList
        self.followerList = followerList
        self.blockedUsers = blockedUsers
        self.favoriteGenres = favoriteGenres
        self.bookshelves = bookshelves
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.profilePhoto = profilePhoto
    }
} //End of class

extension User {
    
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let firstName = ckRecord[UserStrings.firstNameKey] as? String,
            let lastName = ckRecord[UserStrings.lastNameKey] as? String,
            let bio = ckRecord[UserStrings.bioKey] as? String,
            let favoriteAuthor = ckRecord[UserStrings.favoriteAuthorKey] as? String,
            let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference else {return nil}
        
        var favoriteBooks: [String] = []
        if let result = ckRecord[UserStrings.favoriteBooksKey] as? [String] {
            favoriteBooks = result
        }
        
        var favoriteGenres: [String] = []
        if let result = ckRecord[UserStrings.favoriteGenresKey] as? [String] {
            favoriteGenres = result
        }
        
        var blockedUsers: [String] = []
        if let result = ckRecord[UserStrings.blockedUsersKey] as? [String] {
            blockedUsers = result
        }
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                guard let url = photoAsset.fileURL else {return nil}
                let data = try Data(contentsOf: url)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Failed to transform asset to data - \(error) - \(error.localizedDescription)")
            }
        }
        
        self.init(username: username, firstName: firstName, lastName: lastName, bio: bio, favoriteAuthor: favoriteAuthor, favoriteBooks: favoriteBooks, bookclubs: [], friendList: [], followerList: [], blockedUsers: blockedUsers, favoriteGenres: favoriteGenres, bookshelves: [], recordID: ckRecord.recordID, appleUserRef: appleUserRef, profilePhoto: foundPhoto)
    }
    
} //End of extension

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        setValuesForKeys([
            UserStrings.firstNameKey : user.firstName,
            UserStrings.lastNameKey : user.lastName,
            UserStrings.usernameKey : user.username,
            UserStrings.bioKey : user.bio,
            UserStrings.favoriteAuthorKey : user.favoriteAuthor,
//            UserStrings.bookclubKey : user.bookclub,
//            UserStrings.friendListKey : user.friendList,
            
            //UserStrings.followerListKey : user.followerList,
            //UserStrings.bookshelvesKey : user.bookshelves,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
        if user.favoriteGenres.count > 0 {
            self.setValue(user.favoriteGenres, forKey: UserStrings.favoriteGenresKey)
        }
        if user.favoriteBooks.count > 0 {
            self.setValue(user.favoriteBooks, forKey: UserStrings.favoriteBooksKey)
        }
        if let photoAsset = user.photoAsset {
            self.setValue(photoAsset, forKey: UserStrings.photoAssetKey)
        }
    }
} //End of extension
