//
//  Message.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/22/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import Foundation

class Message {
    
    var userId: String
    var text: String
    var timestamp: Int
    
    init(userId: String, text: String, timestamp: Int) {
        self.userId = userId
        self.text = text
        self.timestamp = timestamp
    }
}
