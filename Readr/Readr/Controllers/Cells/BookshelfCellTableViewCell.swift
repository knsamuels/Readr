//
//  BookshelfCellTableViewCell.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfCellTableViewCell: UITableViewCell {

    var bookshelf: Bookshelf? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleOfBookShelfTextField: UITextField!
    
    @IBOutlet weak var bookCountLabel: UILabel!
    
    @IBOutlet weak var book1Label: UILabel!
    
    @IBOutlet weak var book2Label: UILabel!
    
    @IBOutlet weak var book3Label: UILabel!
    
    @IBOutlet weak var book4Label: UILabel!
    
    @IBOutlet weak var book5Label: UILabel!
    
    
    
    func updateViews() {
        guard let bookshelf = bookshelf else {return}
        titleOfBookShelfTextField.text = bookshelf.title
        bookCountLabel.text = "\(bookshelf.books.count)"
    
    }
}


