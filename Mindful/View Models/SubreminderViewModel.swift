//
//  SubreminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class SubreminderViewModel: ReminderViewModelProtocol {

    var reminder: Reminder!
    var context: NSManagedObjectContext
    var reminders: [Reminder]

    init(_ reminder: Reminder) {
        self.reminder = reminder
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        reminders = [Reminder]()

        initializeTableData()
    }

    func addReminder() {
        let subreminder = Reminder(context: context)
        let nextIndex = reminders.count

        subreminder.setup(index: nextIndex, subreminder: true)
        reminders.insert(subreminder, at: 0)
        reminder.addToSubReminders(subreminder)

        saveReminders()
    }

    func getSectionViewModelItem() -> ReminderViewModelItem {
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

    private func initializeTableData() {
        guard let subreminderSet = reminder.subReminders else {
            return
        }

        for item in subreminderSet {
            let subreminder = item as! Reminder
            reminders.append(subreminder)
        }

        reminders.sort {
            if $0.completed == $1.completed {
                if $0.completed {
                    return $0.completedDate! as Date > $1.completedDate! as Date
                }
                return $0.index > $1.index
            }
            return !$0.completed && $1.completed
        }

        updateIndices()

        for item in reminders {
            print("Sub", item.index, ", completed:", item.completed, ", title:", item.title)
        }
    }
}
