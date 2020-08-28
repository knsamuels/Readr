//
//  UIViewControllerExtension.swift
//  Readr
//
//  Created by Bryan Workman on 8/28/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
