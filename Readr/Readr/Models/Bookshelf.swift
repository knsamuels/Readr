//
//  Bookshelf.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

struct BookshelfStrings {
    static let recordTypeKey = "Bookshelf"
    static let titleKey = "Title"
    static let booksKey = "Books"
    static let userRefKey = "userReference"
    static let colorRefKey = "color"
    static let timestampKey = "timestamp"
}

class Bookshelf {
    var title: String
    var books: [String]
    let recordID: CKRecord.ID
    let userReference: CKRecord.Reference?
    var color: String
    let timestamp: Date
    
    init(title:String, books: [String] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userReference: CKRecord.Reference?, color: String, timestamp: Date = Date()) {
        self.title = title
        self.books = books
        self.recordID = recordID
        self.userReference = userReference
        self.color = color
        self.timestamp = timestamp
    }
} //End of class

extension Bookshelf {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[BookshelfStrings.titleKey] as? String,
            let color = ckRecord[BookshelfStrings.colorRefKey] as? String,
            let timestamp = ckRecord[BookshelfStrings.timestampKey] as? Date else {return nil}
        
        let books = ckRecord[BookshelfStrings.booksKey] as? [String]
        
        let userReference = ckRecord[BookshelfStrings.userRefKey] as? CKRecord.Reference
        
        self.init(title: title, books: books ?? [], recordID: ckRecord.recordID, userReference: userReference, color: color, timestamp:timestamp)
    }
} //End of extension

extension CKRecord {
    convenience init(bookshelf: Bookshelf ) {
        self.init(recordType: BookshelfStrings.recordTypeKey, recordID: bookshelf.recordID)
        
        self.setValuesForKeys([
            BookshelfStrings.titleKey : bookshelf.title,
            BookshelfStrings.colorRefKey : bookshelf.color,
            BookshelfStrings.timestampKey : bookshelf.timestamp
        ])
        
        self.setValue(bookshelf.books, forKey: BookshelfStrings.booksKey)
    
        if let reference = bookshelf.userReference {
            self.setValue(reference, forKey: BookshelfStrings.userRefKey)
        }
    }
} //End of extension

extension Bookshelf: Equatable {
    static func == (lhs: Bookshelf, rhs: Bookshelf) -> Bool {
        return lhs.recordID == rhs.recordID
    }
} //End of extension
