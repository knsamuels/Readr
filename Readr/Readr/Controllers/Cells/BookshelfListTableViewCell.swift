//
//  BookshelfCellTableViewCell.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

protocol BookshelfSpinnerDelegate: AnyObject {
    func stopSpinning()
}

class BookshelfListTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundColorView: ReadenView!
    @IBOutlet weak var titleOfBookShelfLabel: UILabel!
    @IBOutlet weak var bookCountLabel: UILabel!
    @IBOutlet weak var book1Label: UILabel!
    @IBOutlet weak var book2Label: UILabel!
    @IBOutlet weak var book3Label: UILabel!
    @IBOutlet weak var book4Label: UILabel!
    @IBOutlet weak var book5Label: UILabel!
    
    //MARK: - Properties
    var bookshelf: Bookshelf? {
        didSet {
            fetchBooks()
        }
    }
    var books: [Book] = []
    weak var spinnerDelegate: BookshelfSpinnerDelegate?
    
    //MARK: - Helper Methods
    func fetchBooks() {
        guard let bookshelf = bookshelf else {return}
        BookController.shared.fetchFirstFiveBooks(bookshelf: bookshelf) { (result) in
            switch result {
            case .success(let books):
                self.books = books
                self.updateViews()
            case .failure(_):
                print("could not fetch 5 books for this bookshelf")
            }
        }
    }
    
    func updateViews() {
        guard let bookshelf = bookshelf else {return}
        titleOfBookShelfLabel.text = bookshelf.title
        bookCountLabel.text = "\(bookshelf.books.count) books"
        
        if bookshelf.color == "blue" {
            backgroundColorView.backgroundColor = .readenBlue
        } else if bookshelf.color == "green" {
            backgroundColorView.backgroundColor = .readenGreen
        } else if bookshelf.color == "yellow" {
            backgroundColorView.backgroundColor = .readenYellow
        } else if bookshelf.color == "orange" {
            backgroundColorView.backgroundColor = .readenOrange
        } else if bookshelf.color == "brown" {
            backgroundColorView.backgroundColor = .readenBrown
        } else if bookshelf.color == "purple" {
            backgroundColorView.backgroundColor = .readenPurple
        } else {
            backgroundColorView.backgroundColor = .readenBlue
        }
        
        book1Label.isHidden = false
        book2Label.isHidden = false
        book3Label.isHidden = false
        book4Label.isHidden = false
        book5Label.isHidden = false
        switch books.count {
        case 0:
            book1Label.isHidden = true
            book2Label.isHidden = true
            book3Label.isHidden = true
            book4Label.isHidden = true
            book5Label.isHidden = true
        case 1:
            book1Label.text = books[0].title
            book2Label.isHidden = true
            book3Label.isHidden = true
            book4Label.isHidden = true
            book5Label.isHidden = true
        case 2:
            book1Label.text = books[0].title
            book2Label.text = books[1].title
            book3Label.isHidden = true
            book4Label.isHidden = true
            book5Label.isHidden = true
        case 3:
            book1Label.text = books[0].title
            book2Label.text = books[1].title
            book3Label.text = books[2].title
            book4Label.isHidden = true
            book5Label.isHidden = true
        case 4:
            book1Label.text = books[0].title
            book2Label.text = books[1].title
            book3Label.text = books[2].title
            book4Label.text = books[3].title
            book5Label.isHidden = true
        default:
            book1Label.text = books[0].title
            book2Label.text = books[1].title
            book3Label.text = books[2].title
            book4Label.text = books[3].title
            book5Label.text = books[4].title
        }
        
        spinnerDelegate?.stopSpinning()
        
        backgroundColorView.layer.shadowColor = UIColor.gray.cgColor
        backgroundColorView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        backgroundColorView.layer.shadowRadius = 2.0
        backgroundColorView.layer.shadowOpacity = 1.0
        backgroundColorView.layer.masksToBounds = false
        backgroundColorView.layer.shadowPath = UIBezierPath(roundedRect: backgroundColorView.bounds, cornerRadius: backgroundColorView.layer.cornerRadius).cgPath
    }
}//End of class


