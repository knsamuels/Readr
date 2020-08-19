//
//  SearchCollectionViewCell.swift
//  Readr
//
//  Created by Bryan Workman on 8/18/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageRating: UILabel!
    
   

    var volumeInfo: Book? {
        didSet {
            updateViews()
            
        }
    }
        
    func updateViews() {
        guard let volumeInfo = volumeInfo else {return}
        titleLabel.text = volumeInfo.title
        averageRating.text = "Rating: \(String(volumeInfo.averageRating ?? 0))"
        bookImageView.image = volumeInfo.coverImage ?? UIImage(named: "noImage")
    }
    
}

