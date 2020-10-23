//
//  PlaceholderViewController.swift
//  Readr
//
//  Created by Bryan Workman on 9/9/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
    var bookshelf: Bookshelf?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        if let bookshelf = bookshelf {
            print("we got a bookshelf (\(bookshelf.title))-- placeholder")
        }
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bookshelf = bookshelf else {return}
        if segue.identifier == "toAlertVC" {
            let destination = segue.destination as? AlertViewController
            destination?.bookshelf = bookshelf
        }
    }
    
} //End of class
