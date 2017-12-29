//
//  ReminderTableViewModelItem.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 11/28/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

class ReminderViewModelItem {

    var completed: Bool
    var title: String
    var detail: String?
    var priority: Priority
    var isSubreminder: Bool
    var hasSubreminders: Bool

    init(completed: Bool, title: String, detail: String?, priority: Priority, isSubreminder: Bool, hasSubreminders: Bool) {
        self.completed = completed
        self.title = title
        self.detail = detail
        self.priority = priority
        self.isSubreminder = isSubreminder
        self.hasSubreminders = hasSubreminders
    }
}
