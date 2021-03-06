//
//  BookshelfListViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/23/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var userBookshelves: [Bookshelf] = []
    var newColor = ""
    var newTitle = ""
    var isNewBookshelf = false
    var bookshelfToUpdate: Bookshelf?
    let group = DispatchGroup()
    let defaults = UserDefaults.standard

    private lazy var loadingScreen: RLogoLoadingView = {
        let view = RLogoLoadingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpViews()
        showLoadingScreen()
//        defaults.set(false, forKey: "DidPresentTermsAlert")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        fetchAllUsersBookshelves()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if defaults.bool(forKey: "DidPresentTermsAlert") == false {
            presentTermsAlert()
            defaults.set(true, forKey: "DidPresentTermsAlert")
        }
    }
    
    //MARK: - Actions
    @IBAction func optionButtonTapped(_ sender: Any) {
        presentCustomAlert()
    }
    
    @IBAction func unwindToShelfList( sender: UIStoryboardSegue) {
        if isNewBookshelf == true {
            BookshelfController.shared.createBookshelf(title: newTitle, color: newColor) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let bookshelf):
                        self.userBookshelves.append(bookshelf)
                        self.tableView.reloadData()
                    case .failure(_):
                        print("Unable to create bookshelf.")
                    }
                }
            }
        } else {
            guard let bookshelfToUpdate = bookshelfToUpdate else {return}
            BookshelfController.shared.updateBookshelf(bookshelf: bookshelfToUpdate, title: newTitle, color: newColor) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.tableView.reloadData()
                    case .failure(_):
                        print("could not update Bookshelf")
                    }
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    func presentTermsAlert() {
        let alertController = UIAlertController(title: "Terms of Service", message: "Hate speech is prohibited on Readen. We define hate speech as a direct attack on people bases on race, ethnicity, national origin, religious affilation, sexual orientation, gender or disability. Readen also has a zero tolerance for inappropriate or adult images in Bookclubs or Bios. Users are given the ability to block or report a User or Bookclub that is violating this policy. Violation of these policies will result in removal from the app.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default)
        alertController.addAction(acceptAction)
        self.present(alertController, animated: true)
    }
    
    private func setUpViews() {
        tableView.separatorColor = .clear
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        self.title = "Bookshelves"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    func fetchAllUsersBookshelves() {
        BookshelfController.shared.fetchAllBookshelves { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookshelves):
                    self.userBookshelves = bookshelves
                    self.tableView.reloadData()
                case .failure(_):
                    print("we could not fetch the users bookshelves")
                }
            }
        }
    }
    
    func presentCustomAlert() {
        guard let customAlert = UIStoryboard(name: "Alert", bundle: .main).instantiateViewController(withIdentifier: "AlertVC") as? PlaceholderViewController else
        {return}
        present(customAlert, animated: true)
    }
    
    func presentEditCustomAlert(bookshelf: Bookshelf) {
        guard let customAlert = UIStoryboard.init(name: "Alert", bundle: .main).instantiateViewController(withIdentifier: "AlertVC") as? PlaceholderViewController else
        {return}
        customAlert.bookshelf = bookshelf
        present(customAlert, animated: true)
    }
    
    private func showLoadingScreen() {
        view.addSubview(loadingScreen)
        NSLayoutConstraint.activate([
            loadingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            loadingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Tableview Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBookshelves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookshelfCell", for: indexPath) as? BookshelfListTableViewCell else {return UITableViewCell()}
        
        group.enter()
        
        let bookshelf = userBookshelves[indexPath.row]
        cell.bookshelf = bookshelf
        cell.spinnerDelegate = self
        return cell
    }
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed) in
            
            let alertController = UIAlertController(title: "Delete Shelf?", message: nil, preferredStyle: .alert)
            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                let bookshelfToDelete = self.userBookshelves[indexPath.row]
                guard let index = self.userBookshelves.firstIndex(of: bookshelfToDelete) else { return}
                if bookshelfToDelete.title != "Favorites" {
                    BookshelfController.shared.deleteBookshelf(bookshelf: bookshelfToDelete) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self.userBookshelves.remove(at: index)
                                self.tableView.reloadData()
                            case .failure(_):
                                print("no - error")
                            }
                        }
                    }
                }
            }
            alertController.addAction(cancelAlertAction)
            alertController.addAction(deleteAlertAction)
            self.present(alertController, animated: true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed) in
            let bookshelfToSend = self.userBookshelves[indexPath.row]
            self.bookshelfToUpdate = bookshelfToSend 
            self.presentEditCustomAlert(bookshelf: bookshelfToSend)
        }
    
        if userBookshelves[indexPath.row].title != "Favorites" {
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
            configuration.performsFirstActionWithFullSwipe = false
             return configuration
        } else {
           let configuration = UISwipeActionsConfiguration(actions: [editAction])
            configuration.performsFirstActionWithFullSwipe = false
             return configuration
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookshelfListToBookShelf" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookshelfDetailTableViewController else {return}
            let bookshelfToSend = userBookshelves[indexPath.row]
            destination.bookshelf = bookshelfToSend
        }
    }
} //End of class

extension BookshelfListViewController: BookshelfSpinnerDelegate {
    func stopSpinning() {
        group.leave()
        group.notify(queue: .main) {
            self.loadingScreen.removeFromSuperview()
        }
    }
} //End of extension 
