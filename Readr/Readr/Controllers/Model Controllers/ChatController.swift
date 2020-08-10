//
//  ChatController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import CloudKit

class ChatController {
    
    static let shared = ChatController()
    
    var chats: [Chat] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
//    class Chat {
//    var name: String
//    var members: [User]
//    var messages: [Message]
    
    func createChat(members: [User], messages: [Message], completion: @escaping (Result<Bool, ChatError>) -> Void ) {
        let newChat = Chat(members: members, messages: messages)
        let newChatRecord = CKRecord(chat: newChat)
        publicDB.save(newChatRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                let savedChat = Chat(ckRecord: record) else { return
                    completion(.failure(.couldNotUnwarp))}
            
            self.chats.append(savedChat)
            completion(.success(true))
        }
    }
    
    func fetchAllChats(completion: @escaping (Result<Bool, ChatError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ChatStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            guard let records = records else {return
                completion(.failure(.couldNotUnwarp))}
            
            let chats: [Chat] = records.compactMap { Chat(ckRecord: $0)}
            self.chats = chats
            
            completion(.success(true))
        }
        
    }
    
}
