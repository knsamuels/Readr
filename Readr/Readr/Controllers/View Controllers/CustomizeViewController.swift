//
//  CustomizeViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class CustomizeViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var blackView: UIView!
    
    //MARK: - Lifecycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(self.presentAuthorVC), userInfo:nil, repeats: false)
    }
    
    //MARK: - Helper Methods
    @objc func presentAuthorVC() {
        DispatchQueue.main.async {
            let authorVC = UIStoryboard(name: "LogIn", bundle: nil).instantiateViewController(withIdentifier: "favAuthorVC")
            authorVC.modalPresentationStyle = .fullScreen
            self.present(authorVC, animated: true, completion: nil)
        }
    }
} //End of class
