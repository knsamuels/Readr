//
//  BookshelfListViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 9/23/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class BookshelfListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var userBookshelves: [Bookshelf] = []
    var newColor = ""
    var newTitle = ""
    let group = DispatchGroup()
    
    
    private lazy var loadingScreen: RLogoLoadingView = {
        let view = RLogoLoadingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "BOOKSHELF"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        //        self.navigationController?.navigationBar.tintColor = .black
        tableView.separatorColor = .clear
        showLoadingScreen()
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAllUsersBookshelves()
    }
    
    // MARK: - Actions
    @IBAction func unwindToShelfList( sender: UIStoryboardSegue) {
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
    }
    
    @IBAction func optionButtonTapped(_ sender: Any) {
        presentCustomAlert()
    }
    
    //Mark: - Helper Functions
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
        guard let customAlert = UIStoryboard(name: "Alert", bundle: .main).instantiateViewController(withIdentifier: "AlertVC") as? PlaceholderViewController else {return}
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookshelfToDelete = userBookshelves[indexPath.row]
            guard let index = userBookshelves.firstIndex(of: bookshelfToDelete) else { return}
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
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: - Navigation
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
}
