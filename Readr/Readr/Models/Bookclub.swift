//
//  Bookclub.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct BookclubConstants {
    static let recordTypeKey = "Bookclub"
    fileprivate static let nameKey = "name"
    fileprivate static let descriptionKey = "description"
    fileprivate static let adminKey = "admin"
    fileprivate static let adminContactInfoKey = "adminContactInfo"
    fileprivate static let membersKey = "members"
    fileprivate static let profilePictureKey = "profilePicture"
    fileprivate static let currentlyReadingKey = "currentlyReading"
    fileprivate static let pastReadsKey = "pastReads"
    fileprivate static let memberMessagesKey = "memberMessages"
    fileprivate static let meetingInfoKey = "meetingInfo"
    fileprivate static let memberCapacityKey = "memberCapacity"
}

class Bookclub {
    var name: String
    var description: String
    var admin: [User]
    var adminContactInfo: String
    var members: [User]
    var profilePicture: UIImage
    var currentlyReading: [String]
    var pastReads: [String]
    var memberMessages: [Message]
    var meetingInfo: String
    var memberCapacity: Int
    
    
    
    init(name: String, admin: [User], adminContactInfo: String, members: [User], description: String, profilePicture: UIImage, currentlyReading: [String], pastReads: [String], memberMessages: [Message], meetingInfo: String, memberCapacity: Int) {
        self.name = name
        self.admin = admin
        self.adminContactInfo = adminContactInfo
        self.members = members
        self.description = description
        self.profilePicture = profilePicture
        self.currentlyReading = currentlyReading
        self.pastReads = pastReads
        self.memberMessages = memberMessages
        self.meetingInfo = meetingInfo
        self.memberCapacity = memberCapacity
    }
}

extension CKRecord {
    
    convenience init(bookclub: Bookclub)  {
        self.init(recordType: BookclubConstants.recordTypeKey)
        
        self.setValuesForKeys([
            BookclubConstants.nameKey : bookclub.name,
            BookclubConstants.adminKey : bookclub.admin,
            BookclubConstants.adminContactInfoKey: bookclub.adminContactInfo,
            BookclubConstants.membersKey : bookclub.members,
            BookclubConstants.descriptionKey : bookclub.description,
            BookclubConstants.profilePictureKey : bookclub.profilePicture,
            BookclubConstants.currentlyReadingKey : bookclub.currentlyReading,
            BookclubConstants.pastReadsKey : bookclub.pastReads,
            BookclubConstants.memberMessagesKey : bookclub.memberMessages,
            BookclubConstants.meetingInfoKey : bookclub.meetingInfo,
            BookclubConstants.memberCapacityKey : bookclub.memberCapacity
        ])
    }
}

extension Bookclub {
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[BookclubConstants.nameKey] as? String,
            let admin = ckRecord[BookclubConstants.adminKey] as? [User],
            let adminContactInfo = ckRecord[BookclubConstants.adminContactInfoKey] as? String,
            let members = ckRecord[BookclubConstants.membersKey] as? [User],
            let description = ckRecord[BookclubConstants.descriptionKey] as? String,
            let profilePicture = ckRecord[BookclubConstants.profilePictureKey] as? UIImage,
            let currentlyReading = ckRecord[BookclubConstants.currentlyReadingKey] as? [String],
            let pastReads = ckRecord[BookclubConstants.pastReadsKey] as? [String],
            let memberMessages = ckRecord[BookclubConstants.memberMessagesKey] as? [Message],
            let meetingInfo = ckRecord[BookclubConstants.meetingInfoKey] as? String,
            let memberCapacity = ckRecord[BookclubConstants.memberCapacityKey] as? Int else {return nil}
        
        self.init(name: name, admin: admin, adminContactInfo: adminContactInfo, members: members, description: description, profilePicture: profilePicture, currentlyReading: currentlyReading, pastReads: pastReads, memberMessages: memberMessages, meetingInfo: meetingInfo, memberCapacity: memberCapacity)
        
    }
}

