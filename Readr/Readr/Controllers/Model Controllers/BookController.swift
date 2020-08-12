//
//  BookController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import UIKit.UIImage

// https://www.googleapis.com/books/v1/volumes?q=the+48+laws+of+power
struct StringConstants {
    fileprivate static let baseURLString = "https://www.googleapis.com/books/v1"
    fileprivate static let volumeComponentString = "volumes"
    fileprivate static let queryKey = "q"
    //    fileprivate static let apiKey = "key"
    //   fileprivate static let apiValue = "AIzaSyB7OAyL1j0A0g4HxGjDzY78c3Qz9dcuEzU"
}

class BookController {
    
    static func fetchBooksWith(searchTerm: String, completion: @escaping(Result<[Book], BookError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invaildURL))}
        let volumeURL = baseURL.appendingPathComponent(StringConstants.volumeComponentString)
        
        var compnents = URLComponents(url: volumeURL, resolvingAgainstBaseURL: true)
        //let apiQuery = URLQueryItem(name: StringConstants.apiKey, value: StringConstants.apiValue)
        let searchQuery = URLQueryItem(name: StringConstants.queryKey, value: searchTerm)
        
        compnents?.queryItems = [searchQuery]
        guard let finalURL = compnents?.url else {return completion(.failure(.invaildURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) {(data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let items = topLevelObject.items
                var books: [Book] = []
                
                for item in items {
                    //    let newBook = VolumeInfo(title: item.volumeInfo.title, description: item.volumeInfo.description, averageRating: item.volumeInfo.averageRating)
                    //  books.append(newBook)
                    let newBook = item.book
                    books.append(newBook)
                }
                
                return completion(.success(books))
                
            } catch {
                print(error.localizedDescription)
                print(error)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImage(book: ImageLinks, completion: @escaping(Result<UIImage, BookError>) -> Void) {
        guard  let url = book.thumbnail else {return}
        print(url)
        
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            guard let thumbnailImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(thumbnailImage))
        }.resume()
    }
}


