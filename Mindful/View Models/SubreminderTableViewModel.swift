//
//  SubreminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class SubreminderTableViewModel {

    var context: NSManagedObjectContext!
    var reminder: Reminder!
    var subreminders = [Reminder]()

    init(withReminder reminder: Reminder) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        context = appDelegate.persistentContainer.viewContext

        self.reminder = reminder

        guard let subremindersSet = reminder.subReminders else {
            return
        }
        for sub in subremindersSet {
            let subreminder = sub as! Reminder
            self.subreminders.append(subreminder)
        }
    }

    func getReminderTableViewModelItem(forIndexPath indexPath: IndexPath) -> ReminderViewModelItem {
        let reminder = getReminder(forIndexPath: indexPath)

        let completed = reminder.completed
        let title = reminder.title!
        var detail: String?

        if let creationDate = reminder.creationDate as Date? {
            detail = creationString(creationDate)
        }

        let priority = Priority(rawValue: (reminder.priority))!
        let subreminder = reminder.subreminder

        return ReminderViewModelItem(completed: completed, title: title, detail: detail, priority: priority, subreminder: subreminder)
    }
}
