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
    var subreminder: Bool

    init(completed: Bool, title: String, detail: String?, priority: Priority, subreminder: Bool) {
        self.completed = completed
        self.title = title
        self.detail = detail
        self.priority = priority
        self.subreminder = subreminder
    }
}
