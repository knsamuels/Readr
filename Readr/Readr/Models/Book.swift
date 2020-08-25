//
//  Book.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

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
    var coverImage: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case title, description, averageRating, authors, imageLinks, industryIdentifiers
    }
}

struct ImageLinks: Decodable {
    let thumbnail: URL?
}

struct IndustryIdentifiers: Decodable {
    let identifier: String
}

extension Book: SearchableRecord {

    func matches(searchTerm: String) -> Bool {

        if title.lowercased().contains(searchTerm.lowercased()) {
            return true
        } else {
            return false
        }
    }
}//End of extension

extension Book: Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.industryIdentifiers == rhs.industryIdentifiers
    }
}

extension IndustryIdentifiers: Equatable {
    static func == (lhs: IndustryIdentifiers, rhs: IndustryIdentifiers) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
