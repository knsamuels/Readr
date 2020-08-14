//
//  BookshelfController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import CloudKit

class BookshelfController {
    
    
    static let shared = BookshelfController()
    
    var bookshelf: [Bookshelf] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    func createBookshelf(title: String, completion: @escaping (Result<Bookshelf, BookshelfError>) -> Void ) {
        
        guard let user = UserController.shared.currentUser else {return completion(.failure(.noUserLoggedIn))}
        let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        let newBookshelf = Bookshelf(title: title, userReference: userRef)
        let newBookshelfRecord = CKRecord(bookshelf: newBookshelf)
        publicDB.save(newBookshelfRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                let savedBookshelf = Bookshelf(ckRecord: record) else { return completion(.failure(.couldNotUnwarp))}
            
            UserController.shared.currentUser?.bookshelves.append(savedBookshelf)
            completion(.success(savedBookshelf))
            
        }
    }
    
    func fetchAllBookshelfs(completion: @escaping (Result<[Bookshelf], BookshelfError>) -> Void) {
        guard let user = UserController.shared.currentUser else {return completion(.failure(.noUserLoggedIn))}
        let userRef = user.recordID
        //let userRef = CKRecord.Reference(recordID: user.recordID, action: .none)
        let predicate = NSPredicate(format: "%K == %@", BookshelfStrings.userRefKey, userRef)
        let query = CKQuery(recordType: BookshelfStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            guard let records = records else {return completion(.failure(.couldNotUnwarp))}
            
            let bookshelf: [Bookshelf] = records.compactMap { Bookshelf(ckRecord: $0)}
            self.bookshelf = bookshelf
            
            completion(.success(bookshelf))
        }
    }

    func updateBookshelf(bookshelf: Bookshelf, completion: @escaping (Result<Bookshelf, BookshelfError>) -> Void) {
        
        let record = CKRecord(bookshelf: bookshelf)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            return completion(.failure(.ckError(error)))
            }
        guard let record = records?.first,
            let updateBookshelf = Bookshelf(ckRecord: record) else { return
                completion(.failure(.couldNotUnwarp))}
            print("Successfully updated the record with ID: \(updateBookshelf.recordID)")
            completion(.success(updateBookshelf))
        }
        publicDB.add(operation)
    }
    
    func deleteBookshelf(bookshelf: Bookshelf, completion: @escaping (Result<Bool, BookshelfError>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [bookshelf.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            if records?.count == 0 {
                print("Successfully deleted records from CloudKit")
                completion(.success(true))
            } else {
                return completion(.failure(.unableToDeleteRecord))
            }
        }
        publicDB.add(operation)
    }
}
