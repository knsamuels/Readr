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
    static let nameKey = "name"
    fileprivate static let descriptionKey = "description"
    fileprivate static let adminKey = "admin"
    fileprivate static let adminContactInfoKey = "adminContactInfo"
    static let membersKey = "members"
    fileprivate static let profilePictureKey = "profilePicture"
    static let currentlyReadingKey = "currentlyReading"
    fileprivate static let pastReadsKey = "pastReads"
    fileprivate static let meetingInfoKey = "meetingInfo"
    fileprivate static let memberCapacityKey = "memberCapacity"
    fileprivate static let blockedUsersKey = "blockedUsers"
    fileprivate static let photoAssetKey = "photoAsset"
    fileprivate static let reportCountKey = "reportCount"
    static let recordIDKey = "recordID"
}

class Bookclub {
    var name: String
    var description: String
    var admin: CKRecord.Reference
    var adminContactInfo: String
    var members: [CKRecord.Reference]
    var currentlyReading: String
    var pastReads: [String]
    var meetingInfo: String
    var memberCapacity: Int
    var recordID: CKRecord.ID
    var blockedUsers: [String]
    var reportCount: Int
    var profilePicture: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset? {
        get {
            guard photoData != nil else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let finalURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: finalURL)
            } catch {
                print("There was an error writing our photo data to a file url - \(error) - \(error.localizedDescription)")
            }
            return CKAsset(fileURL: finalURL)
        }
    }
    
    init(name: String, admin: CKRecord.Reference, adminContactInfo: String, members: [CKRecord.Reference], description: String, profilePicture: UIImage?, currentlyReading: String, pastReads: [String] = [],  meetingInfo: String = "", memberCapacity: Int, blockedUsers: [String] = [], reportCount: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.admin = admin
        self.adminContactInfo = adminContactInfo
        self.members = members
        self.description = description
        self.currentlyReading = currentlyReading
        self.pastReads = pastReads
        self.meetingInfo = meetingInfo
        self.memberCapacity = memberCapacity
        self.blockedUsers = blockedUsers
        self.recordID = recordID
        self.reportCount = reportCount
        self.profilePicture = profilePicture
    }
} //End of class

extension CKRecord {
    convenience init(bookclub: Bookclub)  {
        self.init(recordType: BookclubConstants.recordTypeKey, recordID: bookclub.recordID)
        
        self.setValuesForKeys([
            BookclubConstants.nameKey : bookclub.name,
            BookclubConstants.adminKey : bookclub.admin,
            BookclubConstants.adminContactInfoKey: bookclub.adminContactInfo,
            BookclubConstants.membersKey : bookclub.members,
            BookclubConstants.descriptionKey : bookclub.description,
            BookclubConstants.currentlyReadingKey : bookclub.currentlyReading,
            BookclubConstants.meetingInfoKey : bookclub.meetingInfo,
            BookclubConstants.memberCapacityKey : bookclub.memberCapacity
        ])
        self.setValue(bookclub.pastReads, forKey: BookclubConstants.pastReadsKey)
        self.setValue(bookclub.reportCount, forKey: BookclubConstants.reportCountKey)
        if bookclub.blockedUsers.count > 0 {
            self.setValue(bookclub.blockedUsers, forKey: BookclubConstants.blockedUsersKey)
        }
        if let photoAsset = bookclub.photoAsset {
            self.setValue(photoAsset, forKey: BookclubConstants.photoAssetKey)
        }
    }
} //End of extension

extension Bookclub {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[BookclubConstants.nameKey] as? String,
            let admin = ckRecord[BookclubConstants.adminKey] as? CKRecord.Reference,
            let adminContactInfo = ckRecord[BookclubConstants.adminContactInfoKey] as? String,
            let members = ckRecord[BookclubConstants.membersKey] as? [CKRecord.Reference],
            let description = ckRecord[BookclubConstants.descriptionKey] as? String,
            let currentlyReading = ckRecord[BookclubConstants.currentlyReadingKey] as? String,
            let meetingInfo = ckRecord[BookclubConstants.meetingInfoKey] as? String,
            let memberCapacity = ckRecord[BookclubConstants.memberCapacityKey] as? Int else {return nil}
        
        var pastReads: [String] = []
        if let result = ckRecord[BookclubConstants.pastReadsKey] as? [String] {
            pastReads = result
        }
        var blockedUsers: [String] = []
        if let result = ckRecord[BookclubConstants.blockedUsersKey] as? [String] {
            blockedUsers = result
        }
        var reportCount: Int = 0
        if let result = ckRecord[BookclubConstants.reportCountKey] as? Int {
            reportCount = result
        }
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[BookclubConstants.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Failed to transform asset to data - \(error) - \(error.localizedDescription)")
            }
        }
        
        self.init(name: name, admin: admin, adminContactInfo: adminContactInfo, members: members, description: description, profilePicture: foundPhoto, currentlyReading: currentlyReading, pastReads: pastReads, meetingInfo: meetingInfo, memberCapacity: memberCapacity, blockedUsers: blockedUsers, reportCount: reportCount, recordID: ckRecord.recordID)
    }
} //End of extension

extension Bookclub: Equatable {
    static func == (lhs: Bookclub, rhs: Bookclub) -> Bool {
        return lhs.recordID == rhs.recordID
    }
} //End of extension 
