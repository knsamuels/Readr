//
//  RLogoLoading.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class RLogoLoadingView: UIView {
    
    private lazy var rLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        addSubview(rLogo)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            rLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            rLogo.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            rLogo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            rLogo.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: centerYAnchor, constant: 10)
        ])
        activityIndicator.startAnimating()
        
    }
}




