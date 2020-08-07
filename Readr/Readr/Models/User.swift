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
    static let recordTypekey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let firstNameKey = "firstName"
    fileprivate static let lastNameKey = "lastName"
    fileprivate static let passwordKey = "password"
    fileprivate static let bioKey = "bio"
    fileprivate static let favoriteBooksKey = "favoriteBooks"
    fileprivate static let bookclubKey = "bookClub"
    fileprivate static let friendListKey = "friendList"
    fileprivate static let followerListKey = "followerList"
    fileprivate static let favoriteGenresKey = "favoriteGenres"
    fileprivate static let bookshelvesKey = "Bookshelf"
    fileprivate static let bookclubReferenceKey = "bookclubReference"
    static let appleUserRefKey = "appleUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}

class User {
    var username: String
    var firstName: String
    var lastName: String
    var password: String
    var bio: String
    var favoriteBooks: [String]
    var bookclub: [Bookclub]
    var friendList: [User]
    var followerList: [User]
    var favoriteGenres: [String]
    var bookshelves: [Bookshelf]
    var recordID: CKRecord.ID
    var bookclubReference: CKRecord.Reference?
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
    
    init(username: String, firstName: String, lastName: String, password: String, bio: String = "", favoriteBooks: [String] = [], bookclub: [Bookclub] = [], friendList: [User] = [], followerList: [User] = [], favoriteGenres: [String] = [], bookshelves: [Bookshelf] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), bookshelfReference: CKRecord.Reference, appleUserRef: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.bio = bio
        self.favoriteBooks = favoriteBooks
        self.bookclub = bookclub
        self.friendList = friendList
        self.followerList = followerList
        self.favoriteGenres = favoriteGenres
        self.bookshelves = bookshelves
        self.recordID = recordID
        self.bookclubReference = bookshelfReference
        self.appleUserRef = appleUserRef
        self.profilePhoto = profilePhoto
    }
} //End of class

extension User {
    
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let firstName = ckRecord[UserStrings.firstNameKey] as? String,
            let lastName = ckRecord[UserStrings.lastNameKey] as? String,
            let password = ckRecord[UserStrings.passwordKey] as? String,
            let bookshelfReference = ckRecord[UserStrings.bookclubReferenceKey] as? CKRecord.Reference,
            let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference else {return nil}
            
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
        
        self.init(username: username, firstName: firstName, lastName: lastName, password: password, recordID: ckRecord.recordID, bookshelfReference: bookshelfReference, appleUserRef: appleUserRef, profilePhoto: foundPhoto)
    }
    
} //End of extension

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypekey, recordID: user.recordID)
        setValuesForKeys([
            UserStrings.firstNameKey : user.firstName,
            UserStrings.lastNameKey : user.lastName,
            UserStrings.usernameKey : user.username,
            UserStrings.passwordKey : user.password,
            UserStrings.bioKey : user.bio,
            UserStrings.favoriteBooksKey : user.favoriteBooks,
            UserStrings.bookclubKey : user.bookclub,
            UserStrings.friendListKey : user.friendList,
            UserStrings.followerListKey : user.followerList,
            UserStrings.favoriteGenresKey : user.favoriteGenres,
            UserStrings.bookshelvesKey : user.bookshelves,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
        
        if let reference = user.bookclubReference {
            self.setValue(reference, forKey: UserStrings.bookclubReferenceKey)
        }
        
        if let photoAsset = user.photoAsset {
            self.setValue(photoAsset, forKey: UserStrings.photoAssetKey)
        }
    }
} //End of extension
