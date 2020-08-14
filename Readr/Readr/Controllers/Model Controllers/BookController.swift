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
    
    static let shared = BookController()
    
    static func fetchBooksWith(searchTerm: String, completion: @escaping(Result<[Book], BookError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invalidURL))}
        let volumeURL = baseURL.appendingPathComponent(StringConstants.volumeComponentString)
        
        var compnents = URLComponents(url: volumeURL, resolvingAgainstBaseURL: true)
        //let apiQuery = URLQueryItem(name: StringConstants.apiKey, value: StringConstants.apiValue)
        let searchQuery = URLQueryItem(name: StringConstants.queryKey, value: searchTerm)
        
        compnents?.queryItems = [searchQuery]
        guard let finalURL = compnents?.url else {return completion(.failure(.invalidURL))}
        
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
    
    static func fetchOneBookWith(ISBN: String, completion: @escaping(Result<Book, BookError>) -> Void) {
        print("5")
        guard let baseURL = URL(string: StringConstants.baseURLString) else {return completion(.failure(.invalidURL))}
        let volumeURL = baseURL.appendingPathComponent(StringConstants.volumeComponentString)
        
        var compnents = URLComponents(url: volumeURL, resolvingAgainstBaseURL: true)
        //let apiQuery = URLQueryItem(name: StringConstants.apiKey, value: StringConstants.apiValue)
        let searchQuery = URLQueryItem(name: StringConstants.queryKey, value: ISBN)
        
        compnents?.queryItems = [searchQuery]
        guard let finalURL = compnents?.url else {return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) {(data, _, error) in
            print("6")
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let item = topLevelObject.items.first else {return completion(.failure(.unableToDecode))}
                var book = item.book
                guard let imageLinks = book.imageLinks else {
                    return completion(.success(book))
                }
                print("7")
                self.fetchImage(imageLinks: imageLinks) { (result) in
                    print("10")
                    switch result {
                    case .success(let image):
                        book.coverImage = image
                        return completion(.success(book))
                    case .failure(_):
                        print("We were not able to find an image for the book")
                        return completion(.failure(.invalidURL))
                    }
                }
            } catch {
                print(error.localizedDescription)
                print(error)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImage(imageLinks: ImageLinks, completion: @escaping(Result<UIImage, BookError>) -> Void) {
        guard  let url = imageLinks.thumbnail else {return}
        print(url)
        print("8")
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            print("9")
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            guard let thumbnailImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(thumbnailImage))
        }.resume()
    }
    
    func fetchFavoriteBooks(forUser user: User, completion: @escaping (Result<[Book], BookError>) -> Void) {
        let group = DispatchGroup()
        var books: [Book] = []
        print("4")
        for i in user.favoriteBooks {
            group.enter()
            BookController.fetchOneBookWith(ISBN: i) { (result) in
              print("yeah the book is back!")
                switch result {
                case .success(let book):
                    books.append(book)
                case .failure(_):
                    print("error fetching user's fav books")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("11")
            completion(.success(books))
        }
    }
}


