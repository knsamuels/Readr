//
//  BookclubError.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/10/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

enum BookclubError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
}
