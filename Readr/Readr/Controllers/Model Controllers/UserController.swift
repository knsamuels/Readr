//
//  UserController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //MARK: - Properties
    static let shared = UserController()
    
    var currentUser: User?
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    
    //Create
    func createUser(username: String, firstName: String, lastName: String,  favoriteAuthor: String, completion: @escaping (Result<User, UserError>) -> Void) {
        fetchAppleUserReference { (result) in
            switch result {
            case .success(let reference):
                // remove 29-32
                let newUser = User(username: username, firstName: firstName, lastName: lastName, favoriteAuthor: favoriteAuthor, appleUserRef: reference)
//                newUser.favoriteBooks = ["9780399230035", "9780394800011", "9781478937968"]
//                newUser.favoriteGenres = ["Romance", "Comedy", "Children's"]
//                newUser.bio = "I love to read"
                let userRecord = CKRecord(user: newUser)
                
                self.publicDB.save(userRecord) { (record, error) in
                    if let error = error {
                        print("There was an error saving a user to the cloud - \(error) - \(error.localizedDescription)")
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = record,
                        let savedUser = User(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
                    print("Successfully saved User: \(savedUser.username) to the cloud.")
                    
                    completion(.success(savedUser))
                }
            case .failure(let error):
                print(error.errorDescription ?? "There was an error creating User")
            }
        }
    }
    
    //Read(Fetch)
    func fetchUser(completion: @escaping (Result<User, UserError>) -> Void) {
        fetchAppleUserReference { (result) in
            switch result {
            case .success(let reference):
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserRefKey, reference])
                
                let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
                
                self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                    if let error = error {
                        print("There was an error fetching a user - \(error) - \(error.localizedDescription)")
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = records?.first,
                        let fetchedUser = User(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
                    
                    print("Fetched User: \(fetchedUser.username)")
                    completion(.success(fetchedUser))
                }
                
            case .failure(let error):
                print(error.errorDescription ?? "There was an error fetching User")
            }
        }
    }
    
    func fetchUsersWith(searchTerm: String?, completion: @escaping (Result<[User], UserError>) -> Void) {
        
        var predicate: NSPredicate
        
        if let searchTerm = searchTerm {
            predicate = NSPredicate(format: "self CONTAINS %@", argumentArray: [searchTerm])
        } else {
            predicate = NSPredicate(value: true)
        }
        
        let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching a user - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            let fetchedUsers = records.compactMap { User(ckRecord: $0) }
            
            completion(.success(fetchedUsers))
        }
    }
    
    func fetchUsername(username: String, completion: @escaping (Result<User, UserError>) -> Void) {
        
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.usernameKey, username])
        
        let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
        
        self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error fetching a user - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
                let fetchedUser = User(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            completion(.success(fetchedUser))
        }
    }
    
    func fetchAppleUserReference(completion: @escaping (Result<CKRecord.Reference, UserError>) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("There was an error fetching the user's apple record id - \(error) - \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                completion(.success(reference))
            }
        }
    }
    
    //Update
    func updateUser(user: User, completion: @escaping (Result<User, UserError>) -> Void) {
        
        let record = CKRecord(user: user)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("There was an error updating the user -- \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = records?.first,
                let updatedUser = User(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            completion(.success(updatedUser))
        }
        publicDB.add(operation)
    }

    
    //Delete
    func deleteUser(user: User, completion: @escaping (Result<Bool, UserError>) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [user.recordID])
        
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
            if let error = error {
                print("There was an error deleting a user record -- \(error) -- \(error.localizedDescription)")
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
