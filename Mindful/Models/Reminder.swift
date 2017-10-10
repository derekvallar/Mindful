//
//  Reminder.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

struct Reminder {

    var title: String
    var detail: String
    var creationDate: Date
    var alarmDate: Date?
    var priority: Priority

    init(title: String, detail: String, creationDate: Date, remindDate: Date?, priority: Priority) {
        self.title = title
        self.detail = detail
        self.creationDate = creationDate
        self.alarmDate = remindDate
        self.priority = priority
    }

    init(entity: ReminderEntity) {
        self.title = entity.title!
        self.detail = entity.detail!
        self.creationDate = entity.creationDate!
        self.alarmDate = entity.remindDate
        self.priority = Priority(rawValue: Int(entity.priority))!
    }
}

