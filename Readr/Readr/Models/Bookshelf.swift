//
//  Bookshelf.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

class Bookshelf {
    var title: String
    var books: [Book]
    
    init(title:String, books: [Book] = []) {
        self.title = title
        self.books = books
    }
}

