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
    fileprivate static let chatKey = "chat"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let photoAsset = "photoAsset"
    fileprivate static let userReferenceKey = "userReference"
    static let chatReferenceKey = "chatReference"
}

class Message {
    var text: String?
    var user: User
    var chat: Chat
    var timestamp: Date
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
    var chatReference: CKRecord.Reference?
    
    init(text: String?, user: User, chat: Chat, timestamp: Date = Date(), image: UIImage?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, chatReference: CKRecord.Reference?) {
        self.text = text
        self.user = user
        self.chat = chat
        self.timestamp = timestamp
        self.recordID = recordID
        self.userReference = userReference
        self.chatReference = chatReference
    }
} //End of class

extension Message {
    
    convenience init?(ckRecord: CKRecord){
        guard let user = ckRecord[MessageStrings.userKey] as? User,
            let chat = ckRecord[MessageStrings.chatKey] as? Chat,
            let timestamp = ckRecord[MessageStrings.timestampKey] as? Date else {return nil}
        
        let text = ckRecord[MessageStrings.textKey] as? String
        
        let userReference = ckRecord[MessageStrings.userReferenceKey] as? CKRecord.Reference
        
        let chatReference = ckRecord[MessageStrings.chatReferenceKey] as? CKRecord.Reference
        
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
        
        self.init(text: text, user: user, chat: chat, timestamp: timestamp, image: image, recordID: ckRecord.recordID, userReference: userReference, chatReference: chatReference)
    }
} //End of extension

extension CKRecord {
    
    convenience init(message: Message) {
        self.init(recordType: MessageStrings.recordTypeKey, recordID: message.recordID)
        
        self.setValuesForKeys([
            MessageStrings.userKey : message.user,
            MessageStrings.chatKey : message.chat,
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
        
        if let chatRef = message.chatReference {
            self.setValue(chatRef, forKey: MessageStrings.chatReferenceKey)
        }
    }
} //End of extension
