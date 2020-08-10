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
    
    
    static let sharedInstance = BookshelfController()
    
    var bookshelf: [Bookshelf] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    func createBookshelf(title: String, completion: @escaping (Result<Bool, BookshelfError>) -> Void ) {
        let newBookshelf = Bookshelf(title: title)
        let newBookshelfRecord = CKRecord(bookshelf: newBookshelf)
        publicDB.save(newBookshelfRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n \(error)")
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                let savedBookshelf = Bookshelf(ckRecord: record) else { return completion(.failure(.couldNotUnwarp))}
            
            self.bookshelf.append(savedBookshelf)
            completion(.success(true))
            
        }
    }
    
    func fetchAllBookshelfs(completion: @escaping (Result<Bool, BookshelfError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: BookshelfStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            guard let records = records else {return completion(.failure(.couldNotUnwarp))}
            
            let bookshelf: [Bookshelf] = records.compactMap { Bookshelf(ckRecord: $0)}
            self.bookshelf = bookshelf
            
            completion(.success(true))
        }
    }
}
