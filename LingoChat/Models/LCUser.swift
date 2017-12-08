//
//  LCUser.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/24/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

// LCUser(LingoChatUser) because there is already a class named User in Firebase lib.

import Foundation

class LCUser {
    
    var userId: String?
    var username: String?
    var email: String?
    var password: String?
    var timestamp: Int?
    var profileImageUrl: String?
    var lastMessage: String?
    
    init(userId: String?, username: String, profileImageUrl: String?, timestamp: Int, lastMessage: String) {
        self.userId = userId
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.timestamp = timestamp
        self.lastMessage = lastMessage
    }
    
    init(username: String?, profileImageUrl: String?) {
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    
    init(username: String?, email: String?, profileImageUrl: String?) {
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
}
