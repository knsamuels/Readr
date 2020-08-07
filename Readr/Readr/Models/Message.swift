//
//  Message.swift
//  Readr
//
//  Created by Kristin Samuels  on 8/7/20.
//  Copyright © 2020 Kristin Samuels . All rights reserved.
//

import Foundation

struct test {
    static var marcusWasHere = "Hi guys"
}

class Message {
    var timestamp: Date
    var body: String
    var user: User
    
    init(timestamp: Date = Date(), body: String, user: User) {
        self.timestamp = timestamp
        self.body = body
        self.user = user
    }
}
