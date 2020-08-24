//
//  BookshelfError.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

enum BookshelfError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unableToDeleteRecord
    case noUserLoggedIn
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case . couldNotUnwrap :
            return "Unable to unwarp this post"
        case . unableToDeleteRecord:
            return "Unable to delete record from CloudKit"
        case .noUserLoggedIn:
            return "There is no user currently logged in."
        }
    }
}


