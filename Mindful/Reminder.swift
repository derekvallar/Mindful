//
//  Reminder.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

struct Reminder {

    var title: String?
    var detail: String?
    var remindDate: Date?

    init(title: String?, detail: String?, remindDate: Date?) {
        self.title = title
        self.detail = detail
        self.remindDate = remindDate
    }
}

