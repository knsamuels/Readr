//
//  Bookclub.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation
import UIKit

class Bookclub {
    var name: String
    var description: String
    var admin: [User]
    var adminContactInfo: String
    var members: [User]
    var profilePicture: UIImage
    var currentlyReading: [Book]
    var pastReads: [Book]
    var memberMessages: [Message]
    var meetingInfo: String
    var memberCapacity: Int
    
    
    
    init(name: String, admin: [User], adminContactInfo: String, members: [User], description: String, profilePicture: UIImage, currentlyReading: [Book], pastReads: [Book], memberMessages: [Message], meetingInfo: String, memberCapacity: Int) {
        self.name = name
        self.admin = admin
        self.adminContactInfo = adminContactInfo
        self.members = members
        self.description = description
        self.profilePicture = profilePicture
        self.adminContactInfo = adminContactInfo
        self.currentlyReading = currentlyReading
        self.pastReads = pastReads
        self.memberMessages = memberMessages
        self.meetingInfo = meetingInfo
        self.memberCapacity = memberCapacity
    }
}
