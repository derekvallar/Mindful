//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

protocol ReminderViewModelProtocol {
    func getReminder() -> Reminder
    func getReminderCount() -> Int
    func getReminderViewModelItem() -> ReminderViewModelItem
    func getDetailedReminderViewModel() -> DetailedReminderViewModel

    func addReminder()
    func updateReminder()
    func deleteReminder()
}

class ReminderViewModel {

    var reminders = [Reminder]()

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

    func setCompleted(completed: Bool, indexPath: IndexPath) {
        let reminder = getReminder(forIndexPath: indexPath)
        reminder.completed = completed

        if completed {
            reminder.completedDate = Date() as NSDate
        } else {

        }

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
    }

    func updateReminder(title: String?, detail: String?, priority: Priority?, indexPath: IndexPath) {
        var updated = false
        let reminder = getReminder(forIndexPath: indexPath)

        if title != nil && reminder.title != title {
            print("Updating", reminder.title, "to:", title)
            reminder.title = title
            updated = true
        }

        if detail != nil {
            reminder.detail = detail
            updated = true
        }

        if priority != nil {
            reminder.priority = Int16(priority!.rawValue)
            updated = true
        }

        if updated {
            do {
                try context.save()
            } catch {
                print("Error:", error)
            }
        }
    }

    func deleteReminder(atIndexPath indexPath: IndexPath) {
        let reminder = getReminder(forIndexPath: indexPath)
        context.delete(reminder)
        reminders.remove(at: indexPath.row)
        updateIndices()

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
    }

    func detailedReminderViewModelForIndexPath(_ indexPath: IndexPath) -> DetailedReminderViewModel {
        let reminder = getReminder(forIndexPath: indexPath)
        let viewModel = DetailedReminderViewModel(reminder: reminder)
        return viewModel
    }


}
