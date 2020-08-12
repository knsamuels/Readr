//
//  Bookshelf.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//
struct BookshelfStrings {
    static let recordTypeKey = "Bookshelf"
    static let titleKey = "Title"
    static let booksKey = "Books"
    static let userRefKey = "userReference"
}

import Foundation
import CloudKit


class Bookshelf {
    var title: String
    var books: [String]
    let recordID: CKRecord.ID
    let userReference: CKRecord.Reference?
    
    init(title:String, books: [String] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?) {
        self.title = title
        self.books = books
        self.recordID = recordID
        self.userReference = userReference
    }
}

extension Bookshelf {
    convenience init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[BookshelfStrings.titleKey] as? String else {return nil}
        
        var books = ckRecord[BookshelfStrings.booksKey] as? [String]
        
        let userReference = ckRecord[BookshelfStrings.userRefKey] as? CKRecord.Reference
        
        self.init(title: title, books: books ?? [], recordID: ckRecord.recordID, userReference: userReference)
    }
}

extension CKRecord {
    convenience init(bookshelf: Bookshelf ) {
        self.init(recordType: BookshelfStrings.recordTypeKey, recordID: bookshelf.recordID)
        
        self.setValuesForKeys([
            BookshelfStrings.titleKey : bookshelf.title
        ])
        
        if !bookshelf.books.isEmpty {
            self.setValue(bookshelf.books, forKey: BookshelfStrings.booksKey)
        }
        
        if let reference = bookshelf.userReference {
            self.setValue(reference, forKey: BookshelfStrings.userRefKey)
        }
    }
}

extension Bookshelf: Equatable {
    static func == (lhs: Bookshelf, rhs: Bookshelf) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
