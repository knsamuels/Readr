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
    
    //MARK: - Outlets
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewWebView: WKWebView!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var BC1Image: UIImageView!
    @IBOutlet weak var BC2Image: UIImageView!
    @IBOutlet weak var BC3Image: UIImageView!
    @IBOutlet weak var BC1Label: UILabel!
    @IBOutlet weak var BC2Label: UILabel!
    @IBOutlet weak var BC3Label: UILabel!
    @IBOutlet weak var BC1Button: UIButton!
    @IBOutlet weak var BC2Button: UIButton!
    @IBOutlet weak var BC3Button: UIButton!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    //MARK: - Properties
    var book: Book?
    var BCCurrentlyReading: [Bookclub] = []
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReview()
        fetchBookClubsReadingThisBook()
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func optionButton(_ sender: Any) {
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
        
        let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add to Shelf", style: .default) { (_) in
            guard let popUpTBVC = UIStoryboard.init(name: "Readen", bundle: nil).instantiateViewController(withIdentifier: "popUpBookshelfTBVC") as? PopUpBookshelfTableViewController else {return}
            popUpTBVC.modalPresentationStyle = .automatic
            popUpTBVC.bookISBN = isbn
            print(isbn)
            self.present(popUpTBVC, animated: true, completion: nil)
        }
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alertController.view.tintColor = .accentBlack
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: true)
    }
    
    //MARK: - Helper functions
    private func setUpViews() {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        reviewWebView.layer.borderWidth = 0.25
        reviewWebView.layer.borderColor = UIColor.readenBlue.cgColor
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
        reviewWebView.load(URLRequest(url: URL(string: "https://www.goodreads.com/api/reviews_widget_iframe?did=75599&format=html&header_text=Goodreads+reviews+for+The+Adventures+of+Huckleberry+Finn&isbn=\(isbn)&links=660&min_rating=&num_reviews=&review_back=ffffff&stars=000000&stylesheet=&text=444")!))
    }
    
    func fetchBookClubsReadingThisBook() {
        guard let book = book else {return}
        guard let industryIdentifiers = book.industryIdentifiers else {return}
        var isbn = ""
        for industryIdentifier in industryIdentifiers {
            if industryIdentifier.type == "ISBN_13" {
                isbn = industryIdentifier.identifier
            }
        }
        if isbn == "" {
            isbn = industryIdentifiers.first?.identifier ?? ""
        }
        BookclubController.shared.fetchBookClubWithSameCurrentlyReading(book: isbn) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookclubs):
                    self.BCCurrentlyReading = bookclubs
                    self.updateViews()
                case .failure(_):
                    print("we could not get the bookclubs reading the book")
                }
            }
        }
    }
    
    func updateViews() {
        guard let book = book else {return}
        let rating = "\(book.averageRating ?? 0)"
        self.title = book.title
        bookAuthorLabel.text = book.authors?.first ?? "No Author Found"
        bookImageView.image = book.coverImage
        averageRatingLabel.text = rating
        descriptionLabel.text = book.description
        
        let count = BCCurrentlyReading.count
        BC1Image.isHidden = false
        BC1Label.isHidden = false
        BC1Button.isHidden = false
        BC2Image.isHidden = false
        BC2Label.isHidden = false
        BC2Button.isHidden = false
        BC3Image.isHidden = false
        BC3Label.isHidden = false
        BC3Button.isHidden = false
        switch count {
        case 0:
            BC1Image.isHidden = true
            BC1Label.isHidden = true
            BC1Button.isHidden = true
            BC2Image.isHidden = true
            BC2Label.isHidden = true
            BC2Button.isHidden = true
            BC3Image.isHidden = true
            BC3Label.isHidden = true
            BC3Button.isHidden = true
        case 1:
            BC1Image.isHidden = false
            BC1Label.isHidden = false
            BC1Button.isHidden = false
            BC2Image.isHidden = true
            BC2Label.isHidden = true
            BC2Button.isHidden = true
            BC3Image.isHidden = true
            BC3Label.isHidden = true
            BC3Button.isHidden = true
            if let image1 = self.BCCurrentlyReading[0].profilePicture {
                self.BC1Image.image = image1
            } else {
                self.BC1Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC1Label.text = BCCurrentlyReading[0].name
        case 2:
            BC1Image.isHidden = false
            BC1Label.isHidden = false
            BC1Button.isHidden = false
            BC2Image.isHidden = false
            BC2Label.isHidden = false
            BC2Button.isHidden = false
            BC3Image.isHidden = true
            BC3Label.isHidden = true
            BC3Button.isHidden = true
            if let image1 = self.BCCurrentlyReading[0].profilePicture {
                self.BC1Image.image = image1
            } else {
                self.BC1Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC1Label.text = BCCurrentlyReading[0].name
            if let image2 = self.BCCurrentlyReading[1].profilePicture {
                self.BC2Image.image = image2
            } else {
                self.BC2Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC2Label.text = BCCurrentlyReading[1].name
         default:
            BC1Image.isHidden = false
            BC1Label.isHidden = false
            BC1Button.isHidden = false
            BC2Image.isHidden = false
            BC2Label.isHidden = false
            BC2Button.isHidden = false
            BC3Image.isHidden = false
            BC3Label.isHidden = false
            BC3Button.isHidden = false
            if let image1 = self.BCCurrentlyReading[0].profilePicture {
                self.BC1Image.image = image1
            } else {
                self.BC1Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC1Label.text = BCCurrentlyReading[0].name
            if let image2 = self.BCCurrentlyReading[1].profilePicture {
                self.BC2Image.image = image2
            } else {
                self.BC2Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC2Label.text = BCCurrentlyReading[1].name
            if let image3 = self.BCCurrentlyReading[2].profilePicture {
                self.BC3Image.image = image3
            } else {
                self.BC3Image.image = UIImage(named: "ReadenLogoWhiteSpace")
            }
            BC3Label.text = BCCurrentlyReading[2].name
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfDetailToReviewDetailVC" {
            guard let destination = segue.destination as? ReviewDetailViewController else {return}
            let bookToSend = book
            destination.book = bookToSend
        } else if segue.identifier == "BC1ButtonToBookDetail" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = BCCurrentlyReading[0]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "BC2ButtonToBookDetail" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = BCCurrentlyReading[1]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "BC3ButtonToBookDetail" {
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = BCCurrentlyReading[2]
            destination.bookclub = bookclubToSend
        } else if segue.identifier == "BookDetailToBookclubList" {
            guard let destination = segue.destination as? BookclubListTableViewController else {return}
            let bookclubsToSend = BCCurrentlyReading
            destination.bookclubs = bookclubsToSend
        }
    }
} //End of class
