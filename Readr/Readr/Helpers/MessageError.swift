//
//  MessageError.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

enum MessageError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unableToDeleteRecord
    case noUserLoggedIn
    case noRecord
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get a message from the data found."
        case .unableToDeleteRecord:
            return "Unable to delete a message from the cloud."
        case .noUserLoggedIn:
            return "There is no user currently logged in."
        case .noRecord:
            return "There are no new messages"
        }
    }
} //End enum
