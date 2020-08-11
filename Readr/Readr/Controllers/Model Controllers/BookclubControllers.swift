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
    func createBookClub(name: String, admin: [User], adminContactInfo: String, description: String, profilePic: UIImage?, meetingInfo: String, memberCapacity: Int, completion: @escaping(Result<Bookclub, BookclubError>) -> Void) {
       
        let newBC = Bookclub(name: name, admin: admin, adminContactInfo: adminContactInfo, description: description, profilePicture: profilePic, meetingInfo: meetingInfo, memberCapacity: memberCapacity)
        
        let bcRecord = CKRecord(bookclub: newBC)
      
        publicDB.save(bcRecord) { (record, error) in
            if let error = error {
                print("There was an error creating a bookclub -\(error) - \(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let record = record, let savedBC = Bookclub(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
           
            completion(.success(savedBC))
        }
    }
    
    //Read
    func fetchBookclubs(completion: @escaping(Result<[Bookclub], BookclubError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: BookclubConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching all Bookclubs - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched all Bookclubs successfully.")
            
            let fetchBC = records.compactMap { Bookclub(ckRecord: $0) }
            
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