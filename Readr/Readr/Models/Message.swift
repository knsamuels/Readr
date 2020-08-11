//
//  Message.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

struct MessageStrings {
    static let recordTypeKey = "Message"
    fileprivate static let textKey = "text"
    fileprivate static let userKey = "user"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let photoAsset = "photoAsset"
    fileprivate static let userReferenceKey = "userReference"
    static let bookclubReferenceKey = "bookclubReference"
}

class Message {
    var text: String?
    var user: User
    var timestamp: Date
//    var bookclub: Bookclub
    var bookclubReference: CKRecord.Reference?
    var image: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data? = nil
    var photoAsset: CKAsset? {
        get {
            let tempDir = NSTemporaryDirectory()
            let tempDirURL = URL(fileURLWithPath: tempDir)
            let fileURL = tempDirURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                guard let data = photoData else {return nil}
                try data.write(to: fileURL)
                return CKAsset(fileURL: fileURL)
            } catch {
                print(error)
                return nil
            }
        }
    }
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    
    init(text: String?, user: User, timestamp: Date = Date(), image: UIImage?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, bookclubReference: CKRecord.Reference?) {
        self.text = text
        self.user = user
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        self.bookclubReference = bookclubReference
    }
} //End of class

extension Message {
    
    convenience init?(ckRecord: CKRecord){
        guard let user = ckRecord[MessageStrings.userKey] as? User,
            let timestamp = ckRecord[MessageStrings.timestampKey] as? Date else {return nil}
        
        let text = ckRecord[MessageStrings.textKey] as? String
        
        let userReference = ckRecord[MessageStrings.userReferenceKey] as? CKRecord.Reference
        
        let bookclubReference = ckRecord[MessageStrings.bookclubReferenceKey] as? CKRecord.Reference
        
        var image: UIImage?
        if let photoAsset = ckRecord[MessageStrings.photoAsset] as? CKAsset {
            do {
                guard let url = photoAsset.fileURL else {return nil}
                let data = try Data(contentsOf: url)
                image = UIImage(data: data)
            } catch {
                print("Could not transfrom asset to data.")
            }
        }
        
        self.init(text: text, user: user, timestamp: timestamp, image: image, recordID: ckRecord.recordID, userReference: userReference, bookclubReference: bookclubReference)
    }
} //End of extension

extension CKRecord {
    
    convenience init(message: Message) {
        self.init(recordType: MessageStrings.recordTypeKey, recordID: message.recordID)
        
        self.setValuesForKeys([
            MessageStrings.userKey : message.user,
            MessageStrings.timestampKey : message.timestamp
        ])
        
        if let text = message.text {
            self.setValue(text, forKey: MessageStrings.textKey)
        }
        
        if let photoAsset = message.photoAsset {
            self.setValue(photoAsset, forKey: MessageStrings.photoAsset)
        }
        
        if let userRef = message.userReference {
            self.setValue(userRef, forKey: MessageStrings.userReferenceKey)
        }
        
        if let clubRef = message.bookclubReference {
            self.setValue(clubRef, forKey: MessageStrings.bookclubReferenceKey)
        }
    }
} //End of extension
