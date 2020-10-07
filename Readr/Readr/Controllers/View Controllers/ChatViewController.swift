//
//  ChatViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 10/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var bookclubsArray: [Bookclub] = []
    var recentMessage: Message?
    
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
        
        self.title = "Chat"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        showLoadingScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBookclubs()
        
    }
    
    // MARK: - Helper Methods
    func fetchBookclubs() {
        guard let user = UserController.shared.currentUser else {return}
        BookclubController.shared.fetchUsersBookClubs(user: user) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookclubs):
                    self.bookclubsArray = bookclubs
                    if bookclubs.count == 0 {
                        self.loadingScreen.removeFromSuperview()
                    }
                    self.tableView.reloadData()
                case .failure(_):
                    print("Error fetching bookclubs.")
                }
            }
        }
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
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookclubsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        
        let bookclub = bookclubsArray[indexPath.row]
        cell.bookclub = bookclub
        cell.chatSpinnerDelegate = self
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as? MessageViewController
            let bookclub = bookclubsArray[indexPath.row]
            destinationVC?.bookclub = bookclub
        }
    }
} // End of class

extension ChatViewController: ChatSpinnerDelegate {
    func stopSpinning() {
        self.loadingScreen.removeFromSuperview()
    }
}











