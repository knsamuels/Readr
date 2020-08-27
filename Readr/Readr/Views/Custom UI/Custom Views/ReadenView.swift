//
//  ReadenView.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ReadenView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
    }
    
} //End of class

