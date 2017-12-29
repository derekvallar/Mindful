//
//  MainViewControllerMode.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 11/25/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

struct MindfulMode {
    var filter: Bool
    var reminder: ReminderMode
    var action: ActionMode

    init() {
        filter = false
        reminder = .main
        action = .none
    }

    enum ReminderMode {
        case main, completed, subreminders
    }

    enum ActionMode {
        case edit, priority, alarm, none
    }
}
