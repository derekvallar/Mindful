//
//  CreateReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/8/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

class DetailedReminderViewModel {

    var reminder: Reminder!

    init(withIndexPath indexPath: IndexPath) {

        reminder.title = title ?? ""
        reminder.detail = detail ?? ""
        reminder.creationDate = creationDate
        reminder.alarmDate = remindDate
        reminder.priority = priority
    }


}





