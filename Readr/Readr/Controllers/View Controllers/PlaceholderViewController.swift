//
//  PlaceholderViewController.swift
//  Readr
//
//  Created by Bryan Workman on 9/9/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
    //MARK: - Properties
    var bookshelf: Bookshelf?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
     
    //MARK: - Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bookshelf = bookshelf else {return}
        if segue.identifier == "toAlertVC" {
            let destination = segue.destination as? AlertViewController
            destination?.bookshelf = bookshelf
        }
    }
} //End of class
