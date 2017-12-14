//
//  ReminderViewModelProtocol.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation
import CoreData

protocol ReminderViewModelProtocol {
    
    var context: NSManagedObjectContext { get set }
    var reminders: [Reminder] { get set }

    func addReminder()
}

extension ReminderViewModelProtocol {

    func getReminder(forIndexPath indexPath: IndexPath) -> Reminder {
        return reminders[indexPath.row]
    }
    
    func getReminderCount() -> Int {
        return reminders.count
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

    func getDetailedReminderViewModelForIndexPath(_ indexPath: IndexPath) -> DetailedReminderViewModel {
        let reminder = getReminder(forIndexPath: indexPath)
        let viewModel = DetailedReminderViewModel(reminder: reminder)
        return viewModel
    }

    mutating func deleteReminder(atIndexPath indexPath: IndexPath) {
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

    func updateReminder(completed: Bool?, title: String?, detail: String?, priority: Priority?, indexPath: IndexPath) {
        var updated = false
        let reminder = getReminder(forIndexPath: indexPath)

        if completed != nil && reminder.completed != completed {
            reminder.completed = completed!
            if completed! {
                reminder.completedDate = Date() as NSDate
            }
            updated = true
        }

        if title != nil && reminder.title != title {
            reminder.title = title
            updated = true
        }

        if detail != nil && reminder.detail != detail {
            reminder.detail = detail
            updated = true
        }

        if priority != nil && reminder.priority != priority?.rawValue {
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

    func updateIndices() {
        var count = reminders.count
        for reminder in reminders {
            count -= 1
            reminder.index = Int16(count)
        }
    }

    func creationString(_ date: Date) -> String {
        var result = "Created "
        let timeSince = date.timeIntervalSinceNow.rounded() * -1.0

        let daysSince = timeSince.toDays()
        if daysSince > 0 {
            result += String(daysSince) + " day"
            if daysSince > 1 {
                result += "s"
            }
            return result + " ago"
        }

        let hoursSince = timeSince.toHours()
        if hoursSince > 0 {
            result += String(hoursSince) + " hour"
            if hoursSince > 1 {
                result += "s"
            }
            return result + " ago"
        }

        let minutesSince = timeSince.toMinutes()
        if minutesSince > 0 {
            result += String(minutesSince) + " minute"
            if minutesSince > 1 {
                result += "s"
            }
            return result + " ago"
        }

        if timeSince > 0 {
            result += String(Int(timeSince)) + " second"
            if timeSince > 1 {
                result += "s"
            }
            return result + " ago"
        }

        return "Created now"
    }
}