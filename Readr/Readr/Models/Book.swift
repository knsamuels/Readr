//
//  Book.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

struct TopLevelObject: Decodable {
    let items: [Items]
}

struct Items: Decodable {
    let book: Book
    
    enum CodingKeys: String, CodingKey {
        case book = "volumeInfo"
    }
}

struct Book: Decodable {
    let title: String
    let description: String?
    let averageRating: Float?
    let authors: [String]?
    let imageLinks: ImageLinks?
    let industryIdentifiers: [IndustryIdentifiers]?
}

struct ImageLinks: Decodable {
    let thumbnail: URL?
}

struct IndustryIdentifiers: Decodable {
    let identifier: String
}
