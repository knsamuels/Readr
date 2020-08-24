//
//  AppDelegate.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit
//Testing
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(CKContainer.default().publicCloudDatabase)
//        BookclubController.shared.createBookClub(name: "Lord of the rings",
//                                                 adminContactInfo: "123",
//                                                 description: "We are awesome",
//                                                 profilePic: nil,
//                                                 meetingInfo: "Every week",
//                                                 memberCapacity: 10) { (result) in
//                                                    switch result {
//                                                    case .success(_):
//                                                        print("success")
//                                                    case .failure(_):
//                                                        print("failure")
//                                                    }
//        }
//        BookclubController.shared.fetchBookclubs(searchTerm: "awesome") { (result) in
//            switch result {
//            case .success(_):
//                print("success")
//            case .failure(_):
//                print("failure")
//            }
//
//
//        }
//        UserController.shared.createUser(username: "bwork35", firstName: "Bryan", lastName: "Workman", favoriteAuthor: "JK Rowling") { (result) in
//            switch result {
//            case .success(_):
//                print("success")
//            case .failure(_):
//                print("failure")
//            }
//        }
        
//        UserController.shared.fetchUser { (result) in
//            switch result {
//            case .success(let user):
//                UserController.shared.currentUser = user
//                BookshelfController.sharedInstance.fetchAllBookshelfs { (result) in
//                    switch result {
//                    case .success(let bookshelves):
//                        print(bookshelves)
//                    case .failure(_):
//                        print("failure")
//                    }
//                }
//            case .failure(_):
//                print("failure")
//            }
//        }
        
//        BookshelfController.sharedInstance.createBookshelf(title: "Hunger Games") { (result) in
//            switch result {
//            case .success(_):
//                print("success")
//            case .failure(_):
//                print("failure")
//            }
//        }
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

