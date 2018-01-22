//
//  MainViewControllerMode.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 11/25/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

struct MindfulMode {
    var reminder: ReminderMode
    var oldReminder: ReminderMode?
    var action: ActionMode
    var filter: Bool
    var creatingReminder: Bool

    init() {
        reminder = .main
        action = .none
        filter = false
        creatingReminder = false
    }

    enum ReminderMode {
        case main, completed, subreminders
    }

    enum ActionMode {
        case edit, priority, alarm, none
    }
}
