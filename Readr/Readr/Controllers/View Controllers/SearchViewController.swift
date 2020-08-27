//
//  SearchViewController.swift
//  Readr
//
//  Created by Adetokunbo Babatunde on 8/17/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Properties
    var booksIsSelected = true
    var peopleIsSelected = false
    var clubsIsSelected = false
    var booksArray: [Book] = []
    var peopleArray: [User] = []
    var clubsArray: [Bookclub] = []
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.isHidden = true
        collectionView.isHidden = false
        fetchBooksWithAuthor()
        self.title = "SEARCH"
               self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Cochin", size: 20.0)!]
    }
    
    //MARK: - Actions
    @IBAction func booksButtonTapped(_ sender: Any) {
        booksIsSelected = true
        peopleIsSelected = false
        clubsIsSelected = false
        tableView.isHidden = true
        collectionView.isHidden = false
        search()
    }
    
    @IBAction func clubsButtonTapped(_ sender: Any) {
        booksIsSelected = false
        peopleIsSelected = false
        clubsIsSelected = true
        tableView.isHidden = false
        collectionView.isHidden = true
        tableView.reloadData()
        search()
    }
    
    @IBAction func peopleButtonTapped(_ sender: Any) {
        booksIsSelected = false
        peopleIsSelected = true
        clubsIsSelected = false
        tableView.isHidden = false
        collectionView.isHidden = true
        tableView.reloadData()
        search()
    }
    
    //MARK: - Helpers
    
    func fetchBooksWithAuthor() {
        guard let user = UserController.shared.currentUser else {return}
        BookController.fetchBooksWith(searchTerm: user.favoriteAuthor) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.booksArray = books
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.errorDescription ?? "Unable to find author.")
                }
            }
        }
    }
    
    func search() {
        guard let searchTerm = searchBar.text else {return}
        if booksIsSelected == true {
            BookController.fetchBooksWith(searchTerm: searchTerm) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let books):
                        self.booksArray = books
                        self.collectionView.reloadData()
                    case .failure(let error):
                        print(error.errorDescription ?? "Unable to fetch books.")
                    }
                }
            }
        } else if peopleIsSelected == true {
            UserController.shared.fetchUsersWith(searchTerm: searchTerm) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let people):
                        self.clubsArray = []
                        self.peopleArray = people
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.errorDescription ?? "Unable to find user.")
                    }
                }
            }
        } else {
            BookclubController.shared.fetchBookclubs(searchTerm: searchTerm) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let clubs):
                        self.peopleArray = []
                        self.clubsArray = clubs
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error.errorDescription ?? "Unable to find bookclub.")
                    }
                }
            }
        }
    }
    
    func presentBookclubVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showBookclubSegue", sender: self)
        }
    }
    
    func presentUserDetailVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showUserDetailSegue", sender: self)
        }
    }
    
    //MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if peopleIsSelected == true {
            return peopleArray.count
        } else {
            return clubsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell()}
        if peopleIsSelected == true {
            let user = peopleArray[indexPath.row]
            cell.user = user
        } else if clubsIsSelected == true {
            let bookclub = clubsArray[indexPath.row]
            cell.bookclub = bookclub
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if clubsIsSelected == true {
            presentBookclubVC()
        } else {
            presentUserDetailVC()
        }
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as? SearchCollectionViewCell else {return UICollectionViewCell()}
        let book = booksArray[indexPath.row]
        cell.volumeInfo = book
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 7.5
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15.0
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookclubSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? BookclubViewController else {return}
            let bookclubToSend = clubsArray[indexPath.row]
            destination.bookclub = bookclubToSend
            
        } else if segue.identifier == "showUserDetailSegue"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? UserDetailViewController else {return}
            let userToSend = peopleArray[indexPath.row]
            destination.user = userToSend
            
        } else if segue.identifier == "searchCellCollectionViewToBDVC" {
            guard let cell = sender as? UICollectionViewCell else {return}
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
            guard let destination = segue.destination as?
                BookDetailViewController else {return}
            let bookToSend = booksArray[indexPath.row]
            destination.book = bookToSend
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
