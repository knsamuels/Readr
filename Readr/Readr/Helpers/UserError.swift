//
//  UserError.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case unableToDeleteRecord
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get a user from the data found."
        case .unableToDeleteRecord:
            return "Undable to delete a record from the cloud."
        }
    }
} //End of enum
