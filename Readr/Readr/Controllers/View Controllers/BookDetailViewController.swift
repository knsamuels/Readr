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
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        fetchReview()
    }
    
    //Mark- Actions
    @IBAction func viewAllButtonTapped(_ sender: Any) {
    }
    @IBAction func deleteBookshelfButtonTapped(_ sender: Any) {
    }
    @IBAction func optionButton(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard let isbn = book?.industryIdentifiers?.first?.identifier else {return}
        let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add to Shelf", style: .default) { (_) in
            guard let popUpTBVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "popUpBookshelfTBVC") as? PopUpBookshelfTableViewController else {return}
            popUpTBVC.modalPresentationStyle = .automatic
            popUpTBVC.bookISBN = isbn
            self.present(popUpTBVC, animated: true, completion: nil)
       }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: true)
    }
    
    //Mark: Helper functions
    func fetchReview() {
        guard let isbn = book?.industryIdentifiers?.first?.identifier else {return}
        reviewWebView.load(URLRequest(url: URL(string: "https://www.goodreads.com/api/reviews_widget_iframe?did=75599&format=html&header_text=Goodreads+reviews+for+The+Adventures+of+Huckleberry+Finn&isbn=\(isbn)&links=660&min_rating=&num_reviews=&review_back=ffffff&stars=000000&stylesheet=&text=444")!))
    }
    
    func updateViews() {
        guard let book = book else {return}
        let rating = "\(book.averageRating ?? 0)"
        self.title = book.title
        bookAuthorLabel.text = book.authors?.first ?? "No Author Found"
        bookImageView.image = book.coverImage
        averageRatingLabel.text = rating
        descriptionLabel.text = book.description
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfDetailToReviewDetailVC" {
            guard let destination = segue.destination as? ReviewDetailViewController else {return}
            let bookToSend = book
            destination.book = bookToSend
        }
    }
}
