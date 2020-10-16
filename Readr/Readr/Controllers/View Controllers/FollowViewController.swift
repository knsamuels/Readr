//
//  FollowViewController.swift
//  Readr
//
//  Created by Kristin Samuels  on 10/3/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit

class FollowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var followTableView: UITableView!
    @IBOutlet weak var followSegmentController: UISegmentedControl!
    
    // MARK: - Properties

    var user: User?
    var followArray: [User] = []
    var isFirstSegment = true 
    
    //MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followTableView.delegate = self
        followTableView.dataSource = self
        
        if isFirstSegment == true {
            followSegmentController.selectedSegmentIndex = 0
        } else {
            followSegmentController.selectedSegmentIndex = 1
        }
        fetchFollowUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sleep(5)
        fetchFollowUsers()
        followTableView.reloadData()
    }
    

    //MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let user = user else {return 0}
//        if FollowSegmentController.selectedSegmentIndex == 0 {
//            return user.followingList.count
//        }  else {
//            return user.followerList.count
//        }
        return followArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as? FollowListTableViewCell else {return UITableViewCell()}
        let user = followArray[indexPath.row]
        cell.member = user
        return cell
    }
    
    //MARK: - Action

    @IBAction func FollowSegmentControllerTapped(_ sender: Any) {
        fetchFollowUsers()
    }
    
    //MARK: - Helper Functions
    
    func fetchFollowUsers() {
       guard let user = user else {return}
        if followSegmentController.selectedSegmentIndex == 0 {
            let group = DispatchGroup()
            var placeHolderArray: [User] = []
            for username in user.followingList {
                group.enter()
                UserController.shared.fetchUsername(username: username) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            placeHolderArray.append(user)
                        case .failure(_):
                            print("Could not get followers")
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                let sortedUsers = placeHolderArray.sorted(by: {$0.firstName < $1.firstName})
                self.followArray = sortedUsers
                self.followTableView.reloadData()
            }
        }  else {
            let group = DispatchGroup()
            var placeHolderArray: [User] = []
            for username in user.followerList {
                group.enter()
                UserController.shared.fetchUsername(username: username) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            placeHolderArray.append(user)
                        case .failure(_):
                            print("Could not get followers")
                        }
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                let sortedUsers = placeHolderArray.sorted(by: {$0.firstName < $1.firstName})
                self.followArray = sortedUsers
                self.followTableView.reloadData()
            }
                  
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followVCToUser" {
            guard let indexPath = followTableView.indexPathForSelectedRow else {return}
            guard let destination = segue.destination as? UserDetailViewController else {return}
            let userToSend = followArray[indexPath.row]
            destination.user = userToSend
        }
    }
}
