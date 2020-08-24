//
//  Bookclub.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

class BookclubController {
    
    // Shared Instance
    static let shared = BookclubController()
    
    // Source of Truth
    var bookclubs: [Bookclub] = []
    
    // Public Cloud Database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    
    //MARK: - CRUD
    
    //Create
    func createBookClub(name: String, adminContactInfo: String, description: String, profilePic: UIImage?, meetingInfo: String, memberCapacity: Int, completion: @escaping(Result<Bookclub, BookclubError>) -> Void) {
//        let ckReference = CKRecord.Reference(recordID: recordID, action: .none)
        guard let user = UserController.shared.currentUser else {return completion(.failure(.couldNotUnwrap))}
        let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
        let newBC = Bookclub(name: name, admin: reference, adminContactInfo: adminContactInfo, members: [reference], description: description, profilePicture: profilePic, currentlyReading: "9780399230035", meetingInfo: meetingInfo, memberCapacity: memberCapacity)
        
        let bcRecord = CKRecord(bookclub: newBC)
        
        publicDB.save(bcRecord) { (record, error) in
            if let error = error {
                print("There was an error creating a bookclub -\(error) - \(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let recordTwo = record, let savedBC = Bookclub(ckRecord: recordTwo ) else { return completion(.failure(.couldNotUnwrap))}
            user.bookclubs.append(savedBC)
            completion(.success(savedBC))
        }
    }
    
    //Read
    //fetch all or with search
    func fetchBookclubs(searchTerm: String?, completion: @escaping(Result<[Bookclub], BookclubError>) -> Void) {
        
        var predicate: NSPredicate
        
        if let searchTerm = searchTerm {
            predicate = NSPredicate(format: "self CONTAINS %@", argumentArray: [searchTerm])
        } else {
            predicate = NSPredicate(value: true)
        }
        
        let query = CKQuery(recordType: BookclubConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching all Bookclubs - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched all Bookclubs successfully.")
            
            let fetchBC = records.compactMap { Bookclub(ckRecord: $0) }
            print(fetchBC.count)
            for bookclub in fetchBC {
                print(bookclub.name)
            }
            return completion(.success(fetchBC))
        }
        
    }
    
    //fetch current user or other users
    func fetchUsersBookClubs(user: User, completion: @escaping(Result<[Bookclub], BookclubError>) -> Void) {
        //guard let userReference = UserController.shared.currentUser else {return completion(.failure(.couldNotUnwrap))}
        
        // come back and check this
        let predicate = NSPredicate(format: "%K CONTAINS %@", argumentArray: [BookclubConstants.membersKey, user.recordID])
        
        let query = CKQuery(recordType: BookclubConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching all Bookclubs - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched all Bookclubs User is in successfully.")
            
            let fetchBC = records.compactMap { Bookclub(ckRecord: $0) }
            print(fetchBC.count)
            for bookclub in fetchBC {
                print(bookclub.name)
            }
            return completion(.success(fetchBC))
        }
        
    }
    
    //fetch with currently reading book
    func fetchBookClubWithSameCurrentlyReading(book: String, completion: @escaping(Result<[Bookclub], BookclubError>) -> Void) {
           
           // COME BACK AND CHECK THIS
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [BookclubConstants.currentlyReadingKey, book])
           
           let query = CKQuery(recordType: BookclubConstants.recordTypeKey, predicate: predicate)
           publicDB.perform(query, inZoneWith: nil) { (records, error) in
               if let error = error {
                   print("There was an error fetching all Bookclubs - \(error) - \(error.localizedDescription)")
                   return completion(.failure(.ckError(error)))
               }
               
               guard let records = records else {return completion(.failure(.couldNotUnwrap))}
               
               print("Fetched all Bookclubs User is in successfully.")
               
               let fetchBC = records.compactMap { Bookclub(ckRecord: $0) }
               print(fetchBC.count)
               for bookclub in fetchBC {
                   print(bookclub.name)
               }
               return completion(.success(fetchBC))
           }
           
       }
    
    //Update
    func update(bookclub: Bookclub, completion: @escaping(Result<Bookclub, BookclubError>) -> Void) {
        
        let record = CKRecord(bookclub: bookclub)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (records, _, error) in 
            if let error = error {
                print("There was an error modifying the Bookclub - \(error) - \(error.localizedDescription) ")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first, let updatedBC = Bookclub(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            return completion(.success(updatedBC))
        }
        
        publicDB.add(operation)
    }
    
    // Delete
    func delete(bookclub: Bookclub, completion: @escaping(Result<Bool, BookclubError>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [bookclub.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("There was an error deleting the record - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordIDs = recordIDs else { return completion(.failure(.couldNotUnwrap))}
            
            if  recordIDs.count > 0 {
                print("Deleted record(s) from CloudKit. \(recordIDs)")
                completion(.success(true))
            } else {
                return completion(.failure(.couldNotUnwrap))
            }
        }
        
        publicDB.add(operation)
    }
}
