//
//  BookshelfCellTableViewCell.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/12/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfListTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundColorView: ReadenView!
    @IBOutlet weak var titleOfBookShelfLabel: UILabel!
    @IBOutlet weak var bookCountLabel: UILabel!
    
    //MARK: - Properties
    var bookshelf: Bookshelf? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Helper Methods
    func updateViews() {
        guard let bookshelf = bookshelf else {return}
        titleOfBookShelfLabel.text = bookshelf.title
        bookCountLabel.text = "\(bookshelf.books.count) books"
    }
    
}//End of class


