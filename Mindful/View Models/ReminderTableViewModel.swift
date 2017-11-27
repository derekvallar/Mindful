//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/4/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableViewModel {

    static let standard = ReminderTableViewModel()
    var context: NSManagedObjectContext!
    var reminders: [Reminder]!

    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not find App Delegate")
            return
        }
        context = appDelegate.persistentContainer.viewContext

        self.initializeTableData(withCompleted: false, completion: nil)
        checkReminders()
    }

    func getReminderCount() -> Int {
        return reminders.count
    }

    func getCompleted(forIndexPath indexPath: IndexPath) -> Bool {
        let reminder = getReminder(forIndexPath: indexPath)
        return reminder.completed
    }

    func getTitle(forIndexPath indexPath: IndexPath) -> String {
        let reminder = getReminder(forIndexPath: indexPath)
        return reminder.title ?? ""
    }

    func getDetail(forIndexPath indexPath: IndexPath) -> String? {
        let reminder = getReminder(forIndexPath: indexPath)

        guard let creationDate = reminder.creationDate as Date? else {
            return "Error: Cannot find reminder detail"
        }

        return self.creationString(creationDate)
    }

    func getPriority(forIndexPath indexPath: IndexPath) -> Priority {
        let reminder = getReminder(forIndexPath: indexPath)
        let intPriority = Int(reminder.priority)

        return Priority(rawValue: intPriority)!
    }

    func addBlankReminder() {
        let reminder = Reminder(context: context)
        let nextIndex = reminders.count
        reminder.setup("", index: nextIndex, priority: Priority.none.rawValue, creationDate: Date())

        reminders.insert(reminder, at: 0)

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
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

        if title != nil {
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
        let reminder = reminders[indexPath.row]
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

    func initializeTableData(withCompleted completed: Bool, completion: ((_ result: Bool) -> Void)?) {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.sortedFetchRequest(withCompleted: completed)
        var fetchedReminders: [Reminder]

        do {
            fetchedReminders = try context.fetch(fetchRequest)
        } catch {
            print("Could not fetch:", error)
            completion?(false)
            return
        }

        self.reminders = fetchedReminders
        completion?(true)
    }

    func removeTableData() {
        reminders.removeAll()
    }

    // TODO: Remove this test function
    func checkReminders() {
        for reminder in reminders {
            print("Title:", reminder.title, ", Completed:", reminder.completed)
        }
    }

    // MARK: - Private Funcs

    private func getReminder(forIndexPath indexPath: IndexPath) -> Reminder {
        let index = indexPath.row
        return reminders[index]
    }

    private func creationString(_ date: Date) -> String {
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

    private func updateIndices() {
        var count = reminders.count
        for reminder in reminders {
            count -= 1
            reminder.index = Int16(count)
        }
    }
}













