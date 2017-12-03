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
    var reminders = [Reminder]()
    var subreminders = [Reminder]()

    var selectedIndexPath: IndexPath!
    var parentIndexPath: IndexPath!

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
        return reminders.count + subreminders.count
    }

    func addReminder() {
        let reminder = Reminder(context: context)
        let nextIndex = reminders.count

        reminder.setup(index: nextIndex, subreminder: false)
        reminders.insert(reminder, at: 0)

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
    }

    func addSubreminder() -> IndexPath {
        let subreminder = Reminder(context: context)
        let nextIndex = subreminders.count
        subreminder.setup(index: nextIndex, subreminder: true)
        subreminders.insert(subreminder, at: 0)

        let parent = getReminder(forIndexPath: parentIndexPath)
        parent.addToSubReminders(subreminder)

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }

        var subreminderIndexPath = parentIndexPath!
        subreminderIndexPath.row += 1

        return subreminderIndexPath
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

        reminders = fetchedReminders
        completion?(true)
    }

    func reminderSelected(indexPath: IndexPath) -> [IndexPath] {
        let reminder = getReminder(forIndexPath: indexPath)
        if !reminder.subreminder {
            parentIndexPath = indexPath
        }
        selectedIndexPath = indexPath

        if let subRemindersSet = reminder.subReminders {
            for anyReminder in subRemindersSet {
                let subreminder = anyReminder as! Reminder
                subreminders.append(subreminder)
            }
        }

        var indices = getSubreminderIndices()
        return indices
    }

    func reminderDeselected(indexPath: IndexPath) -> [IndexPath] {
        var indices = getSubreminderIndices()
        subreminders.removeAll()
        return indices
    }

    func moveReminder(fromIndex start: IndexPath, toIndex end: IndexPath) {
        let reminder = getReminder(forIndexPath: start)

        guard let index = reminders.index(of: reminder) else {
            return
        }

        reminders.remove(at: index)
        reminders.insert(reminder, at: end.row)
    }

    // TODO: Remove this test function
    func checkReminders() {

        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var fetchedReminders: [Reminder]

        do {
            fetchedReminders = try context.fetch(fetchRequest)
            for reminder in fetchedReminders {
                print("Reminder:", reminder.title, "Completed:", reminder.completed, "Sub:", reminder.subreminder)
            }

        } catch {
            print("Could not fetch:", error)
        }
    }

    // MARK: - Private Funcs

    private func getReminder(forIndexPath indexPath: IndexPath) -> Reminder {
        if selectedIndexPath == nil || indexPath.row <= selectedIndexPath.row {
            return reminders[indexPath.row]
        }

        let remainder = indexPath.row - selectedIndexPath.row
        if remainder <= subreminders.count {
            return subreminders[remainder - 1]
        }

        return reminders[indexPath.row - subreminders.count]
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

        count = subreminders.count
        for reminder in subreminders {
            count -= 1
            reminder.index = Int16(count)
        }
    }

    private func getSubreminderIndices() -> [IndexPath] {
        var indices = [IndexPath]()
        let count = subreminders.count

        if parentIndexPath != nil {
            for offset in stride(from: 1, through: count, by: 1) {
                var subIndexPath = parentIndexPath!
                subIndexPath.row += offset
                indices.append(subIndexPath)
            }
        }
        return indices
    }
}













