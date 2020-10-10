//
//  AppDelegate.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkAccountStatus { (success) in
            let fetchedUserStatment = success ? "Successfully retrieved a logged in user" : "Failed to retrieve a logged in user"
            application.applicationIconBadgeNumber = 0
            print(fetchedUserStatment)
        }
        
        //        UITabBar.appearance().tintColor = .black
        //        print(CKContainer.default().publicCloudDatabase)
        
        application.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("There was an error when requesting authorization to send the user a notification -- \(error) -- \(error.localizedDescription)")
                return
            }
            
            success ? print("Successfully authorized to send push notfiication") : print("DENIED, Can't send this person notificiation")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        return true
    }
    
    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        
        CKContainer.default().accountStatus { (status, error) in
            
            if let error = error {
                print("Error checking accountStatus \(error) \(error.localizedDescription)")
                return completion(false)
            }
            else {
                DispatchQueue.main.async {
                    
                    let tabBarController = self.window?.rootViewController
                    
                    let errrorText = "Sign into iCloud in Settings"
                    
                    switch status {
                    case .available:
                        tabBarController?.presentSimpleAlertWith(title: "Yayyy", message: ":) :) :) :) :)")
                        print("MAAAADE ITTTTTT")
                        completion(true);
                        
                    case .noAccount:
                        tabBarController?.presentSimpleAlertWith(title: errrorText, message: "No account found")
                        completion(false)
                        
                    case .couldNotDetermine:
                        tabBarController?.presentSimpleAlertWith(title: errrorText, message: "There was an unknown error fetching your iCloud Account")
                        completion(false)
                        
                    case .restricted:
                        tabBarController?.presentSimpleAlertWith(title: errrorText, message: "Your iCloud account is restricted")
                        completion(false)
                        
                    default:
                        tabBarController?.presentSimpleAlertWith(title: errrorText, message: "Unknown Error")
                    }
                }
            }
        }
    }
    
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        MessageController.shared.subscribeForRemoteNotifications { (error) in
    //            if let error = error {
    //                print("There was an error subscribing for remote notifications -- \(error) -- \(error.localizedDescription)")
    //            }
    //        }
    //    }
    
    //        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //            print("We failed to register for remote notifications. -- \(error) -- \(error.localizedDescription)")
    //        }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("Received: \(userInfo)")
        let dict = userInfo as! [String: NSObject]
        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
        
        if let sub = notification?.subscriptionID {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadEventsTable"), object: nil)
            print("iOS Notification: \(sub)")
//            BookclubController.shared.fetchBookclubWithRecordName(recordName: sub) { (result) in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let bookclub):
//                        MessageController.shared.fetchMessages(for: bookclub) { (result) in
//                            DispatchQueue.main.async {
//                                switch result {
//                                case .success(_):
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadEventsTable"), object: nil)
//                                case .failure(_):
//                                    print("Did not get the messages")
//                                }
//                            }
//                        }
//                    case .failure(_):
//                         print("We were NOT able to fetch bookclub with record name")
//                    }
//                }
//            }
        }
        completionHandler(.newData)
    }
} //End of class

