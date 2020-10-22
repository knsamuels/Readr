//
//  ReadenTextView.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ReadenTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews(){
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
    }
} //End of class
