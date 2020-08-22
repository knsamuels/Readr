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
    }
    
    func fetchReview() {
        guard let isbn = book?.industryIdentifiers?.first?.identifier else {return}
        reviewsWebView.load(URLRequest(url: URL(string: "https://www.goodreads.com/api/reviews_widget_iframe?did=75599&format=html&header_text=Goodreads+reviews+for+The+Adventures+of+Huckleberry+Finn&isbn=\(isbn)&links=660&min_rating=&num_reviews=&review_back=ffffff&stars=000000&stylesheet=&text=444")!))
    }
    
    func updateViews() {
      bookTitleLabel.text = "Title: \(book?.title)"
    }
}
