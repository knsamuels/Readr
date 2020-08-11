//
//  Chat.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

//struct ChatStrings {
//    static let recordTypeKey = "Chat"
//    static let nameKey = "Name"
//    static let memberKey = "Members"
//    static let messagesKey = "Messages"
//}
//
//import Foundation
//import CloudKit
//
//class Chat {
//    var name: String
//    var members: [User]
//    var messages: [Message]
//    
//    let recordID: CKRecord.ID
//    
//    init(name: String = "", members: [User], messages: [Message], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
//        self.name = name
//        self.members = members
//        self.messages = messages
//        self.recordID = recordID
//    }
//}
//
//extension Chat {
//    convenience init?(ckRecord: CKRecord) {
//        guard let members = ckRecord[ChatStrings.memberKey] as? [User],
//            let messages = ckRecord[ChatStrings.messagesKey] as? [Message] else {return nil}
//        
//        self.init(members: members, messages: messages, recordID: ckRecord.recordID)
//    }
//}
//
//extension CKRecord {
//    
//    convenience init(chat: Chat) {
//        self.init(recordType: ChatStrings.recordTypeKey, recordID: chat.recordID)
//        
//        self.setValuesForKeys([
//            ChatStrings.nameKey : chat.name,
//            ChatStrings.memberKey : chat.members,
//            ChatStrings.messagesKey : chat.messages
//        ])
//    }
//}
//
//extension Chat: Equatable {
//    static func == (lhs: Chat, rhs: Chat) -> Bool {
//        return lhs.recordID == rhs.recordID
//    }
//}
