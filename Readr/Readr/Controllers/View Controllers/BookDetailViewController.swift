//
//  BookshelfDetailViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import WebKit

class BookDetailViewController: UIViewController {

    var book: Book?
//    {
//        didSet {
//            loadViewIfNeeded()
//
//        }
//    }
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewImageLabel: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    //Mark- Actions
    
    @IBAction func viewAllButtonTapped(_ sender: Any) {
    }
    @IBAction func deleteBookshelfButtonTapped(_ sender: Any) {
    }
    
    //Mark: Helper functions
    
    func updateViews() {
        guard let book = book else {return}
        self.title = book.title
        bookAuthorLabel.text = book.authors?.first ?? "No Author Found"
        bookImageView.image = book.coverImage
        averageRatingLabel.text = "\(book.averageRating)"
        descriptionLabel.text = book.description
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfDetailToReviewDetailVC" {
            guard let destination = segue.destination as? ReviewDetailViewController else {return}
//            let isbn = book?.industryIdentifiers?.first?.identifier
            let bookToSend = book
            destination.book = bookToSend
        }
    }
}
