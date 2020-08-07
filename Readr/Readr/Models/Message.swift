//
//  Message.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import CloudKit

struct MessageStrings {
    static let recordTypeKey = "Message"
    fileprivate static let textKey = "text"
    fileprivate static let userKey = "user"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let userReferenceKey = "userReference"
}

class Message {
    var text: String
    var user: User
    var timestamp: Date
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference?
    
    init(text: String, user: User, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?) {
        self.text = text
        self.user = user
        self.timestamp = timestamp
        self.userReference = userReference
        self.recordID = recordID
    }
} //End of class

extension Message {
    
    convenience init?(ckRecord: CKRecord){
        guard let text = ckRecord[MessageStrings.textKey] as? String,
            let user = ckRecord[MessageStrings.userKey] as? User,
            let timestamp = ckRecord[MessageStrings.timestampKey] as? Date else {return nil}
        let userReference = ckRecord[MessageStrings.userReferenceKey] as? CKRecord.Reference
        
        self.init(text: text, user: user, timestamp: timestamp, recordID: ckRecord.recordID, userReference: userReference)
    }
} //End of extension

extension CKRecord {
    
    convenience init(message: Message) {
        self.init(recordType: MessageStrings.recordTypeKey, recordID: message.recordID)
        
        self.setValuesForKeys([
            MessageStrings.textKey : message.text,
            MessageStrings.userKey : message.user,
            MessageStrings.timestampKey : message.timestamp
        ])
        
        if let reference = message.userReference {
            self.setValue(reference, forKey: MessageStrings.userReferenceKey)
        }
    }
} //End of extension
