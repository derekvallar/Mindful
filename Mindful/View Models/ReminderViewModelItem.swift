//
//  ReminderTableViewModelItem.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 11/28/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

class ReminderViewModelItem {
    var completed: Bool = false
    var title: String = ""
    var detail: String = ""
    var priority: Priority = Priority.low
    var alarm: Date?
    var alarmString: String?
    var isSubreminder: Bool = false
    var hasSubreminders: Bool = false

    init() {}
}

class ReminderViewModelSaveItem {
    var completed: Bool?
    var title: String?
    var detail: String?
    var priority: Priority?
    var alarm: Date?
    var alarmString: String?

    init() {}
}
