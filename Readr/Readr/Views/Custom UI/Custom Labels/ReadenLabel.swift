//
//  ReadenLabel.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ReadenLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let size = self.font.pointSize
        self.font = UIFont(name: "Cochin", size: size)
    }
} //End of class
