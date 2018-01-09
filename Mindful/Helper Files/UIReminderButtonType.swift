//
//  UIReminderButtonType.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/5/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

enum UIReminderButtonType {
    case reminder(type: ReminderType)
    case category(type: CategoryType)
    case action(type: ActionType)
    case none
}

enum ReminderType {
    case complete, delete
}

enum CategoryType {
    case edit, priority, alarm, subreminders, back, none
}

enum ActionType {
    case lowPriority, mediumPriority, highPriority, alarmButton, alarmOn, alarmOff
}
