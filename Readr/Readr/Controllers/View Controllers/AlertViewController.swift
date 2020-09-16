//
//  AlertViewController.swift
//  Readr
//
//  Created by Bryan Workman on 9/9/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var shelfNameTextField: UITextField!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    //MARK: - Properties
    var blueIsSelected = true
    var greenIsSelected = false
    var yellowIsSelected = false
    var orangeIsSelected = false
    var brownIsSelected = false
    var purpleIsSelected = false
    
    var myColor = ""
    var myTitle = ""
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        blueButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let title = shelfNameTextField.text, !title.isEmpty else {return}
        myTitle = title
        if blueIsSelected {
            myColor = "blue"
        } else if greenIsSelected {
            myColor = "green"
        } else if yellowIsSelected {
            myColor = "yellow"
        } else if orangeIsSelected {
            myColor = "orange"
        } else if brownIsSelected {
            myColor = "brown"
        } else if purpleIsSelected {
            myColor = "purple"
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        blueButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        greenButton.setImage(nil, for: .normal)
        yellowButton.setImage(nil, for: .normal)
        orangeButton.setImage(nil, for: .normal)
        brownButton.setImage(nil, for: .normal)
        purpleButton.setImage(nil, for: .normal)
        blueIsSelected = true
        greenIsSelected = false
        yellowIsSelected = false
        orangeIsSelected = false
        brownIsSelected = false
        purpleIsSelected = false
    }
    @IBAction func greenButtonTapped(_ sender: Any) {
        blueButton.setImage(nil, for: .normal)
        greenButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        yellowButton.setImage(nil, for: .normal)
        orangeButton.setImage(nil, for: .normal)
        brownButton.setImage(nil, for: .normal)
        purpleButton.setImage(nil, for: .normal)
        blueIsSelected = false
        greenIsSelected = true
        yellowIsSelected = false
        orangeIsSelected = false
        brownIsSelected = false
        purpleIsSelected = false
    }
    @IBAction func yellowButtonTapped(_ sender: Any) {
        blueButton.setImage(nil, for: .normal)
        greenButton.setImage(nil, for: .normal)
        yellowButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        orangeButton.setImage(nil, for: .normal)
        brownButton.setImage(nil, for: .normal)
        purpleButton.setImage(nil, for: .normal)
        blueIsSelected = false
        greenIsSelected = false
        yellowIsSelected = true
        orangeIsSelected = false
        brownIsSelected = false
        purpleIsSelected = false
    }
    @IBAction func orangeButtonTapped(_ sender: Any) {
        blueButton.setImage(nil, for: .normal)
        greenButton.setImage(nil, for: .normal)
        yellowButton.setImage(nil, for: .normal)
        orangeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        brownButton.setImage(nil, for: .normal)
        purpleButton.setImage(nil, for: .normal)
        blueIsSelected = false
        greenIsSelected = false
        yellowIsSelected = false
        orangeIsSelected = true
        brownIsSelected = false
        purpleIsSelected = false
    }
    @IBAction func brownButtonTapped(_ sender: Any) {
        blueButton.setImage(nil, for: .normal)
        greenButton.setImage(nil, for: .normal)
        yellowButton.setImage(nil, for: .normal)
        orangeButton.setImage(nil, for: .normal)
        brownButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        purpleButton.setImage(nil, for: .normal)
        blueIsSelected = false
        greenIsSelected = false
        yellowIsSelected = false
        orangeIsSelected = false
        brownIsSelected = true
        purpleIsSelected = false
    }
    @IBAction func purpleButtonTapped(_ sender: Any) {
        blueButton.setImage(nil, for: .normal)
        greenButton.setImage(nil, for: .normal)
        yellowButton.setImage(nil, for: .normal)
        orangeButton.setImage(nil, for: .normal)
        brownButton.setImage(nil, for: .normal)
        purpleButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        blueIsSelected = false
        greenIsSelected = false
        yellowIsSelected = false
        orangeIsSelected = false
        brownIsSelected = false
        purpleIsSelected = true 
    }
    
    
    //MARK: - Helper Methods
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? BookshelfListTableViewController else {return}
        destination.newColor = myColor
        destination.newTitle = myTitle
    }
    
} //End of class
