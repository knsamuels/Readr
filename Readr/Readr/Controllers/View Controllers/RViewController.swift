//
//  RViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/26/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class RViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Timer.scheduledTimer(timeInterval: 3.0, target:self, selector: #selector(self.presentBookshelfVC), userInfo:nil, repeats: false)
    }
    
    @objc func presentBookshelfVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Readen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
} //End of class
