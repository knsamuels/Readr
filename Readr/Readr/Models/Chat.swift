//
//  Chat.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

class Chat {
    var name: String?
    var members: [User]
    var messages: [Message]
    
    init(name: String?, members: [User], messages: [Message]) {
        self.name = name
        self.members = members
        self.messages = messages
    }
}
