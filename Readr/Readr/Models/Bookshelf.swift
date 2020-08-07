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
}

import Foundation
import CloudKit


class Bookshelf {
    var title: String
    var books: [String]
    let recordID: CKRecord.ID
    
    init(title:String, books: [String] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.books = books
        self.recordID = recordID
    }
}

extension Bookshelf {
    convenience init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[BookshelfStrings.titleKey] as? String,
            let books = ckRecord[BookshelfStrings.booksKey] as? [String] else {return nil}
        
        self.init(title: title, books: books, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(bookshelf: Bookshelf ) {
        self.init(recordType: BookshelfStrings.recordTypeKey, recordID: bookshelf.recordID)
        
        self.setValuesForKeys([
            BookshelfStrings.titleKey : bookshelf.title,
            BookshelfStrings.booksKey : bookshelf.books
        ])
    }
}

extension Bookshelf: Equatable {
    static func == (lhs: Bookshelf, rhs: Bookshelf) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
