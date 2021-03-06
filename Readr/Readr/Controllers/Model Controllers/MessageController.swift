//
//  MessageController.swift
//  Readr
//
//  Created by Bryan Workman on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import CloudKit
import UIKit.UIImage

class MessageController {
    
    //MARK: - Properties
    static let shared = MessageController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD Methods
    //Create
    func saveMessage(text: String?, image: UIImage?, bookclub: Bookclub, completion: @escaping (Result<Message, MessageError>) -> Void) {
        
        guard let user = UserController.shared.currentUser else {return completion(.failure(.noUserLoggedIn))}
        let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
        let clubRef = CKRecord.Reference(recordID: bookclub.recordID , action: .deleteSelf)
        let newMessage = Message(text: text, user: user.username, image: image, userReference: userRef, bookclubReference: clubRef)
        
        let messageRecord = CKRecord(message: newMessage)
        
        publicDB.save(messageRecord) { (record, error) in
            if let error = error {
                print("There was an error saving a message:  \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                let savedMessage = Message(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            completion(.success(savedMessage))
        }
    }
    
    //Read(Fetch)
    func fetchMessages(for bookclub: Bookclub, completion: @escaping (Result<[Message], MessageError>) -> Void) {
        
        let bookclubReference = bookclub.recordID
        
        let predicate = NSPredicate(format: "%K == %@", MessageStrings.bookclubReferenceKey, bookclubReference)
        
        let query = CKQuery(recordType: MessageStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching messagesL:  \(error) -- \(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            let fetchedMessages = records.compactMap { Message(ckRecord: $0) }
            let sortedMessages = fetchedMessages.sorted(by: { $0.timestamp > $1.timestamp })
    
            completion(.success(sortedMessages))
        }
    }
    
    func fetchAllMessagesfrom(user: User, completion: @escaping (Result<[Message], MessageError>) -> Void) {
        let userReference = user.recordID
        
        let predicate = NSPredicate(format: "%K == %@", MessageStrings.userReferenceKey, userReference)
        
        let query = CKQuery(recordType: MessageStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching messagesL:  \(error) -- \(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched Message Records Successfully")
            
            let fetchedMessages = records.compactMap { Message(ckRecord: $0) }
            let sortedMessages = fetchedMessages.sorted(by: { $0.timestamp < $1.timestamp })
         
            completion(.success(sortedMessages))
        }
    }
    
    //Update
    func updateMessage(message: Message, completion: @escaping (Result<Message, MessageError>) -> Void) {
        
        let record = CKRecord(message: message)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            
            if let error = error {
                print("There was an error updating the message -- \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
                let updatedMessage = Message(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            completion(.success(updatedMessage))
        }
        publicDB.add(operation)
    }
    
    //Delete
    func deleteMessage(message: Message, completion: @escaping (Result<Bool, MessageError>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [message.recordID])
        
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("There was an error deleting a message record -- \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordIDs = recordIDs else {return completion(.failure(.couldNotUnwrap))}
            
            if recordIDs.count > 0 {
                print("Deleted record(s) from CloudKit. \(recordIDs)")
                completion(.success(true))
            } else {
                return completion(.failure(.unableToDeleteRecord))
            }
        }
        publicDB.add(operation)
    }
} //End class
