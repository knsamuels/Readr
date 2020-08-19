//
//  ChatError.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

enum ChatError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwarp
    case unableToDeleteRecord
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case . couldNotUnwarp :
            return "Unable to unwarp this post"
        case . unableToDeleteRecord:
            return "Unable to delete record from CloudKit"
        }
    }
}
