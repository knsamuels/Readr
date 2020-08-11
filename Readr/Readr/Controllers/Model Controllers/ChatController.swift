////
////  ChatController.swift
////  Readr
////
////  Created by Kristin Samuels  on 8/10/20.
////  Copyright © 2020 Kristin Samuels . All rights reserved.
////
//
//import Foundation
//import CloudKit
//
//class ChatController {
//    
//    static let shared = ChatController()
//    
//    var chats: [Chat] = []
//    
//    let publicDB = CKContainer.default().publicCloudDatabase
//    
//    func createChat(members: [User], messages: [Message], completion: @escaping (Result<Bool, ChatError>) -> Void ) {
//        let newChat = Chat(members: members, messages: messages)
//        let newChatRecord = CKRecord(chat: newChat)
//        publicDB.save(newChatRecord) { (record, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                return completion(.failure(.ckError(error)))
//            }
//            guard let record = record,
//                let savedChat = Chat(ckRecord: record) else { return
//                    completion(.failure(.couldNotUnwarp))}
//            
//            self.chats.append(savedChat)
//            completion(.success(true))
//        }
//    }
//    
//    func fetchAllChats(completion: @escaping (Result<Bool, ChatError>) -> Void) {
//        
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: ChatStrings.recordTypeKey, predicate: predicate)
//        publicDB.perform(query, inZoneWith: nil) { (records, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                completion(.failure(.ckError(error)))
//            }
//            guard let records = records else {return
//                completion(.failure(.couldNotUnwarp))}
//            
//            let chats: [Chat] = records.compactMap { Chat(ckRecord: $0)}
//            self.chats = chats
//            
//            completion(.success(true))
//        }
//    }
//    
//    func updateChat(chat: Chat, completion: @escaping (Result<Chat, ChatError>) -> Void) {
//        
//        let record = CKRecord(chat: chat)
//        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
//        
//        operation.savePolicy = .changedKeys
//        operation.qualityOfService = .userInteractive
//        operation.modifyRecordsCompletionBlock = {(records, _, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                return completion(.failure(.ckError(error)))
//            }
//            guard let record = records?.first,
//                let updatedChat = Chat(ckRecord: record) else { return
//                    completion(.failure(.couldNotUnwarp))}
//            print("Successfully updates the record with ID: \(updatedChat.recordID)")
//            completion(.success(updatedChat))
//        }
//        publicDB.add(operation)
//    }
//    
//    func deleteChat(chat: Chat, completion: @escaping (Result<Bool, ChatError>) -> Void) {
//        
//        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [chat.recordID])
//        
//        operation.savePolicy = .changedKeys
//        operation.qualityOfService = .userInteractive
//        operation.modifyRecordsCompletionBlock = {(records, _, error) in
//            if let error = error {
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                completion(.failure(.ckError(error)))
//            }
//            if records?.count == 0 {
//                print("Successfully deleted records from CloudKit")
//                completion(.success(true))
//            } else {
//                return completion(.failure(.unableToDeleteRecord))
//            }
//        }
//        publicDB.add(operation)
//    }
//}
