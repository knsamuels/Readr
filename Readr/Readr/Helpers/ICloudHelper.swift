//
//  ICloudHelper.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/28/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import UIKit
import CloudKit

//class ICloudHelper {
//
//    static func test() {
//        CKContainer.default().accountStatus { (accountStatus, error) in
//            switch accountStatus {
//            case .available:
//                print("iCloud Available")
//            case .noAccount:
//                self.displayAlertController()
//            case .restricted:
//                self.displayAlertController()
//            case .couldNotDetermine:
//                self.displayAlertController()
//            }
//        }
//    }
//}
//    
//    static func isCloudAvailable(completion: @escaping (Error?) -> Void) {
//        CKContainer.default().accountStatus() { (accountStatus, error) in
//            // Check if there are any errors
//            guard error == nil else {
//                completion(error)
//                return
//            }
//            // Check the iCloud account status
//            switch accountStatus {
//            case .available:
//                // Check if the user is signed into iCloud account
//                if FileManager.default.ubiquityIdentityToken != nil {
//                    // User has signed into iCloud
//                    completion(nil)
//                }
//                else {
//                    // User has not signed into iCloud
//                    let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Please sign in to iCloud on this device.", comment: "")]
//                    let errorNotSignedIn = NSError(domain: "testCloud", code: 101, userInfo: userInfo as! [String : Any])
//                    completion(errorNotSignedIn)
//                }
//            case .noAccount, .restricted, .couldNotDetermine:
//                // Unable to connect to iCloud
//                let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Unable to connect to iCloud. Please sign in to iCloud on this device.", comment: "")]
//                let errorICloudNotAvailable = NSError(domain: "testCloud", code: 101, userInfo: userInfo as! [String : Any])
//                completion(errorICloudNotAvailable)
//            }
//        }
//    }
//
