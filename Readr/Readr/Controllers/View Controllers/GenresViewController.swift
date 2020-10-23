//
//  GenresViewController.swift
//  Readr
//
//  Created by Bryan Workman on 8/24/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var fantasyButton: UIButton!
    @IBOutlet weak var adventureButton: UIButton!
    @IBOutlet weak var romanceButton: UIButton!
    @IBOutlet weak var contemporaryButton: UIButton!
    @IBOutlet weak var dypostianButton: UIButton!
    @IBOutlet weak var mysteryButton: UIButton!
    @IBOutlet weak var horrorButton: UIButton!
    @IBOutlet weak var thrillerButton: UIButton!
    @IBOutlet weak var paranormalButton: UIButton!
    @IBOutlet weak var historicalFictionButton: UIButton!
    @IBOutlet weak var scienceFictionButton: UIButton!
    @IBOutlet weak var memoirButton: UIButton!
    @IBOutlet weak var cookingButton: UIButton!
    @IBOutlet weak var artButton: UIButton!
    @IBOutlet weak var selfHelpPersonalButton: UIButton!
    @IBOutlet weak var developmentButton: UIButton!
    @IBOutlet weak var motivationalButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var guideHowToButton: UIButton!
    @IBOutlet weak var relationshipsButton: UIButton!
    @IBOutlet weak var humorButton: UIButton!
    @IBOutlet weak var childrensButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    
    //MARK: - Properties
    var favGenres: [String] = []
    var fantasyIsSelected = false
    var adventureIsSelected = false
    var romanceIsSelected = false
    var contemporaryIsSelected = false
    var dypostianIsSelected = false
    var mysteryIsSelected = false
    var horrorIsSelected = false
    var thrillerIsSelected = false
    var paranormalIsSelected = false
    var historicalFictionIsSelected = false
    var scienceFictionIsSelected = false
    var memoirIsSelected = false
    var cookingIsSelected = false
    var artIsSelected = false
    var selfHelpPersonalIsSelected = false
    var developmentIsSelected = false
    var motivationalIsSelected = false
    var healthIsSelected = false
    var historyIsSelected = false
    var travelIsSelected = false
    var guideHowToIsSelected = false
    var relationshipsIsSelected = false
    var humorIsSelected = false
    var childrensIsSelected = false
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func finishedButtonTapped(_ sender: Any) {
        guard let user = UserController.shared.currentUser else {return}
        guard favGenres.count > 0 else {return}
        user.favoriteGenres = favGenres
        
        UserController.shared.updateUser(user: user) { (result) in
        }
    }
    
    @IBAction func fantasyButtonTapped(_ sender: Any) {
        fantasyIsSelected.toggle()
        if fantasyIsSelected {
            fantasyButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Fantasy")
            addCount()
        } else {
            fantasyButton.backgroundColor = #colorLiteral(red: 0.2098854482, green: 0.3161664009, blue: 0.4439439476, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Fantasy") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func adventureButtonTapped(_ sender: Any) {
        adventureIsSelected.toggle()
        if adventureIsSelected {
            adventureButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Adventure")
            addCount()
        } else {
            adventureButton.backgroundColor = #colorLiteral(red: 0.354118228, green: 0.3790878952, blue: 0.3499294817, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Adventure") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func romanceButtonTapped(_ sender: Any) {
        romanceIsSelected.toggle()
        if romanceIsSelected {
            romanceButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Romance")
            addCount()
        } else {
            romanceButton.backgroundColor = #colorLiteral(red: 0.7780780196, green: 0.6214153767, blue: 0.3541248441, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Romance") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func contemporaryButtonTapped(_ sender: Any) {
        contemporaryIsSelected.toggle()
        if contemporaryIsSelected {
            contemporaryButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Contemporary")
            addCount()
        } else {
            contemporaryButton.backgroundColor = #colorLiteral(red: 0.6584896445, green: 0.4279785752, blue: 0.3415432572, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Contemporary") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func dypostianButtonTapped(_ sender: Any) {
        dypostianIsSelected.toggle()
        if dypostianIsSelected {
            dypostianButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Dypostian")
            addCount()
        } else {
            dypostianButton.backgroundColor = #colorLiteral(red: 0.5264488459, green: 0.4599625468, blue: 0.4678027034, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Dypostian") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func mysteryButtonTapped(_ sender: Any) {
        mysteryIsSelected.toggle()
        if mysteryIsSelected {
            mysteryButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Mystery")
            addCount()
        } else {
            mysteryButton.backgroundColor = #colorLiteral(red: 0.4279251099, green: 0.3873221874, blue: 0.479637146, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Mystery") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func horrorButtonTapped(_ sender: Any) {
        horrorIsSelected.toggle()
        if horrorIsSelected {
            horrorButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Horror")
            addCount()
        } else {
            horrorButton.backgroundColor = #colorLiteral(red: 0.6585012674, green: 0.3416002989, blue: 0.3790254593, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Horror") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func thrillerButtonTapped(_ sender: Any) {
        thrillerIsSelected.toggle()
        if thrillerIsSelected {
            thrillerButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Thriller")
            addCount()
        } else {
            thrillerButton.backgroundColor = #colorLiteral(red: 0.2098854482, green: 0.3161664009, blue: 0.4439439476, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Thriller") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func paranormalButtonTapped(_ sender: Any) {
        paranormalIsSelected.toggle()
        if paranormalIsSelected {
            paranormalButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Paranormal")
            addCount()
        } else {
            paranormalButton.backgroundColor = #colorLiteral(red: 0.354118228, green: 0.3790878952, blue: 0.3499294817, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Paranormal") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func historicalFictionButtonTapped(_ sender: Any) {
        historicalFictionIsSelected.toggle()
        if historicalFictionIsSelected {
            historicalFictionButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Historical Fiction")
            addCount()
        } else {
            historicalFictionButton.backgroundColor = #colorLiteral(red: 0.7780780196, green: 0.6214153767, blue: 0.3541248441, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Historical Fiction") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func scienceFictionButtonTapped(_ sender: Any) {
        scienceFictionIsSelected.toggle()
        if scienceFictionIsSelected {
            scienceFictionButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Science Fiction")
            addCount()
        } else {
            scienceFictionButton.backgroundColor = #colorLiteral(red: 0.6584896445, green: 0.4279785752, blue: 0.3415432572, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Science Fiction") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func memoirButtonTapped(_ sender: Any) {
        memoirIsSelected.toggle()
        if memoirIsSelected {
            memoirButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Memoir")
            addCount()
        } else {
            memoirButton.backgroundColor = #colorLiteral(red: 0.5264488459, green: 0.4599625468, blue: 0.4678027034, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Memoir") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func cookingButtonTapped(_ sender: Any) {
        cookingIsSelected.toggle()
        if cookingIsSelected {
            cookingButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Cooking")
            addCount()
        } else {
            cookingButton.backgroundColor = #colorLiteral(red: 0.4279251099, green: 0.3873221874, blue: 0.479637146, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Cooking") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func artButtonTapped(_ sender: Any) {
        artIsSelected.toggle()
        if artIsSelected {
            artButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Art")
            addCount()
        } else {
            artButton.backgroundColor = #colorLiteral(red: 0.6585012674, green: 0.3416002989, blue: 0.3790254593, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Art") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func selfHelpPersonalButtonTapped(_ sender: Any) {
        selfHelpPersonalIsSelected.toggle()
        if selfHelpPersonalIsSelected {
            selfHelpPersonalButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Self Help + Personal")
            addCount()
        } else {
            selfHelpPersonalButton.backgroundColor = #colorLiteral(red: 0.2098854482, green: 0.3161664009, blue: 0.4439439476, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Self Help + Personal") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func developmentButtonTapped(_ sender: Any) {
        developmentIsSelected.toggle()
        if developmentIsSelected {
            developmentButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Development")
            addCount()
        } else {
            developmentButton.backgroundColor = #colorLiteral(red: 0.354118228, green: 0.3790878952, blue: 0.3499294817, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Development") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func motivationalButtonTapped(_ sender: Any) {
        motivationalIsSelected.toggle()
        if motivationalIsSelected {
            motivationalButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Motivational")
            addCount()
        } else {
            motivationalButton.backgroundColor = #colorLiteral(red: 0.7780780196, green: 0.6214153767, blue: 0.3541248441, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Motivational") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func healthButtonTapped(_ sender: Any) {
        healthIsSelected.toggle()
        if healthIsSelected {
            healthButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Health")
            addCount()
        } else {
            healthButton.backgroundColor = #colorLiteral(red: 0.6584896445, green: 0.4279785752, blue: 0.3415432572, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Health") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        historyIsSelected.toggle()
        if historyIsSelected {
            historyButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("History")
            addCount()
        } else {
            historyButton.backgroundColor = #colorLiteral(red: 0.5264488459, green: 0.4599625468, blue: 0.4678027034, alpha: 1)
            guard let index = favGenres.firstIndex(of: "History") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func travelButtonTapped(_ sender: Any) {
        travelIsSelected.toggle()
        if travelIsSelected {
            travelButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Travel")
            addCount()
        } else {
            travelButton.backgroundColor = #colorLiteral(red: 0.4279251099, green: 0.3873221874, blue: 0.479637146, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Travel") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func guideHowToButtonTapped(_ sender: Any) {
        guideHowToIsSelected.toggle()
        if guideHowToIsSelected {
            guideHowToButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Guide + How To")
            addCount()
        } else {
            guideHowToButton.backgroundColor = #colorLiteral(red: 0.6585012674, green: 0.3416002989, blue: 0.3790254593, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Guide + How To") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func relationshipsButtonTapped(_ sender: Any) {
        relationshipsIsSelected.toggle()
        if relationshipsIsSelected {
            relationshipsButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Relationships")
            addCount()
        } else {
            relationshipsButton.backgroundColor = #colorLiteral(red: 0.2098854482, green: 0.3161664009, blue: 0.4439439476, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Relationships") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func humorButtonTapped(_ sender: Any) {
        humorIsSelected.toggle()
        if humorIsSelected {
            humorButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Humor")
            addCount()
        } else {
            humorButton.backgroundColor = #colorLiteral(red: 0.354118228, green: 0.3790878952, blue: 0.3499294817, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Humor") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    @IBAction func childrensButtonTapped(_ sender: Any) {
        childrensIsSelected.toggle()
        if childrensIsSelected {
            childrensButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            favGenres.append("Childrens")
            addCount()
        } else {
            childrensButton.backgroundColor = #colorLiteral(red: 0.7780780196, green: 0.6214153767, blue: 0.3541248441, alpha: 1)
            guard let index = favGenres.firstIndex(of: "Childrens") else {return}
            favGenres.remove(at: index)
            minusCount()
        }
    }
    
    //MARK: - Helper Methods
    func addCount() {
        if favGenres.count == 3 {
            nullifyAllButtons()
        }
    }
    
    func minusCount() {
        if favGenres.count == 2 {
            unNullifyAllButtons()
        }
    }
    
    func nullifyAllButtons() {
        fantasyButton.isEnabled = false
        adventureButton.isEnabled = false
        romanceButton.isEnabled = false
        contemporaryButton.isEnabled = false
        dypostianButton.isEnabled = false
        mysteryButton.isEnabled = false
        horrorButton.isEnabled = false
        thrillerButton.isEnabled = false
        paranormalButton.isEnabled = false
        historicalFictionButton.isEnabled = false
        scienceFictionButton.isEnabled = false
        memoirButton.isEnabled = false
        cookingButton.isEnabled = false
        artButton.isEnabled = false
        selfHelpPersonalButton.isEnabled = false
        developmentButton.isEnabled = false
        motivationalButton.isEnabled = false
        healthButton.isEnabled = false
        historyButton.isEnabled = false
        travelButton.isEnabled = false
        guideHowToButton.isEnabled = false
        relationshipsButton.isEnabled = false
        humorButton.isEnabled = false
        childrensButton.isEnabled = false
        
        if fantasyIsSelected {
            fantasyButton.isEnabled = true
        }
        if adventureIsSelected {
            adventureButton.isEnabled = true
        }
        if romanceIsSelected {
            romanceButton.isEnabled = true
        }
        if contemporaryIsSelected {
            contemporaryButton.isEnabled = true
        }
        if dypostianIsSelected {
            dypostianButton.isEnabled = true
        }
        if mysteryIsSelected {
            mysteryButton.isEnabled = true
        }
        if horrorIsSelected {
            horrorButton.isEnabled = true
        }
        if thrillerIsSelected {
            thrillerButton.isEnabled = true
        }
        if paranormalIsSelected {
            paranormalButton.isEnabled = true
        }
        if historicalFictionIsSelected {
            historicalFictionButton.isEnabled = true
        }
        if scienceFictionIsSelected {
            scienceFictionButton.isEnabled = true
        }
        if memoirIsSelected {
            memoirButton.isEnabled = true
        }
        if cookingIsSelected {
            cookingButton.isEnabled = true
        }
        if artIsSelected {
            artButton.isEnabled = true
        }
        if selfHelpPersonalIsSelected {
            selfHelpPersonalButton.isEnabled = true
        }
        if developmentIsSelected {
            developmentButton.isEnabled = true
        }
        if motivationalIsSelected {
            motivationalButton.isEnabled = true
        }
        if healthIsSelected {
            healthButton.isEnabled = true
        }
        if historyIsSelected {
            historyButton.isEnabled = true
        }
        if travelIsSelected {
            travelButton.isEnabled = true
        }
        if guideHowToIsSelected {
            guideHowToButton.isEnabled = true
        }
        if relationshipsIsSelected {
            relationshipsButton.isEnabled = true
        }
        if humorIsSelected {
            humorButton.isEnabled = true
        }
        if childrensIsSelected {
            childrensButton.isEnabled = true
        }
    }
    
    func unNullifyAllButtons() {
        fantasyButton.isEnabled = true
        adventureButton.isEnabled = true
        romanceButton.isEnabled = true
        contemporaryButton.isEnabled = true
        dypostianButton.isEnabled = true
        mysteryButton.isEnabled = true
        horrorButton.isEnabled = true
        thrillerButton.isEnabled = true
        paranormalButton.isEnabled = true
        historicalFictionButton.isEnabled = true
        scienceFictionButton.isEnabled = true
        memoirButton.isEnabled = true
        cookingButton.isEnabled = true
        artButton.isEnabled = true
        selfHelpPersonalButton.isEnabled = true
        developmentButton.isEnabled = true
        motivationalButton.isEnabled = true
        healthButton.isEnabled = true
        historyButton.isEnabled = true
        travelButton.isEnabled = true
        guideHowToButton.isEnabled = true
        relationshipsButton.isEnabled = true
        humorButton.isEnabled = true
        childrensButton.isEnabled = true
    }
} //End of class
