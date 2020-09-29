//
//  ReviewDetailViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/20/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import WebKit

class ReviewDetailViewController: UIViewController {
    
    var bookISBN: String?
    var book: Book?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var reviewsWebView: WKWebView!
    @IBOutlet weak var goodReadsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReview()
        updateViews()
        self.title = "REVIEWS"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func fetchReview() {
        guard let industryIdentifiers = book?.industryIdentifiers else {return}
        var isbn = ""
        for industryIdentifier in industryIdentifiers {
            if industryIdentifier.type == "ISBN_13" {
                isbn = industryIdentifier.identifier
            }
        }
        if isbn == "" {
            isbn = industryIdentifiers.first?.identifier ?? ""
        }
        reviewsWebView.load(URLRequest(url: URL(string: "https://www.goodreads.com/api/reviews_widget_iframe?did=75599&format=html&header_text=Goodreads+reviews+for+The+Adventures+of+Huckleberry+Finn&isbn=\(isbn)&links=660&min_rating=&num_reviews=&review_back=ffffff&stars=000000&stylesheet=&text=444")!))
    }
    
    func updateViews() {
        guard let book = book else {return}
        bookTitleLabel.text = "Title: \(book.title)"
    }
}
