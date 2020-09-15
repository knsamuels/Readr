//
//  PlaceholderViewController.swift
//  Readr
//
//  Created by Bryan Workman on 9/9/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
} //End of class
