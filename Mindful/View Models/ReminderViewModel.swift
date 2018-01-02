//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/4/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class ReminderViewModel {

    var context: NSManagedObjectContext
    var reminders: [Reminder]
    var parentReminder: Reminder?

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        reminders = [Reminder]()

        initializeTableData(withCompleted: false, completion: nil)
    }

    func getReminderCount() -> Int {
        return reminders.count
    }

    func getReminder(forIndexPath indexPath: IndexPath) -> Reminder {
        return reminders[indexPath.row]
    }

    func getReminderItem(forIndexPath indexPath: IndexPath) -> ReminderViewModelItem {
        let reminder = getReminder(forIndexPath: indexPath)
        return getItem(forReminder: reminder)
    }

    func getHeaderReminderItem() -> ReminderViewModelItem {
        return getItem(forReminder: parentReminder!)
    }

    func addReminder() {
        let newReminder = Reminder(context: context)
        let nextIndex = reminders.count

        if let parentReminder = parentReminder {
            newReminder.setup(index: nextIndex, subreminder: true)
            parentReminder.addToSubreminders(newReminder)
        } else {
            newReminder.setup(index: nextIndex, subreminder: false)
        }

        reminders.insert(newReminder, at: 0)
        saveReminders()
    }

    func deleteReminder(atIndexPath indexPath: IndexPath) {
        let reminder = getReminder(forIndexPath: indexPath)
        context.delete(reminder)
        reminders.remove(at: indexPath.row)
        updateIndices()

        saveReminders()
    }

    func updateReminder(completed: Bool?, title: String?, detail: String?, priority: Priority?, indexPath: IndexPath) {
        let reminder = getReminder(forIndexPath: indexPath)

        if let completed = completed {
            reminder.completed = completed
            if completed {
                reminder.completedDate = Date() as NSDate
            }
        }

        if let title = title {
            reminder.title = title
        }

        if let detail = detail {
            reminder.detail = detail
        }

        if let priority = priority {
            reminder.priority = Int16(priority.rawValue)
        }

        saveReminders()
    }

    func updateParentReminder(completed: Bool) {
        guard let parentReminder = parentReminder else {
            return
        }

        parentReminder.completed = completed
        saveReminders()
    }

    func swapReminders(fromIndexPath: IndexPath, to: IndexPath) {
        let fromReminder = getReminder(forIndexPath: fromIndexPath)
        let toReminder = getReminder(forIndexPath: to)
        let fromReminderIndex = fromReminder.index

        print("Swapping:", fromReminder.index, ",", toReminder.index)

        fromReminder.index = toReminder.index
        toReminder.index = fromReminderIndex

        reminders.swapAt(fromIndexPath.row, to.row)
    }

    func saveReminders() {
        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
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
        parentReminder = nil
        completion?(true)
    }

    func initializeSubreminders(ofIndexPath index: IndexPath, completion: ((_ result: Bool) -> Void)?) {
        self.parentReminder = getReminder(forIndexPath: index)
        guard let subreminderSet = parentReminder!.subreminders else {
            completion?(false)
            return
        }

        reminders.removeAll()
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
        completion?(true)

        for item in reminders {
            print("Sub", item.index, ", completed:", item.completed, ", title:", item.title)
        }
    }

    private func getItem(forReminder reminder: Reminder) -> ReminderViewModelItem {
        let completed = reminder.completed
        let title = reminder.title!
        var detail: String?

        if let savedDetail = reminder.detail {
            detail = savedDetail
        }

        let priority = Priority(rawValue: (reminder.priority))!
        let isSubreminder = reminder.isSubreminder

        var isParent = false
        if let subreminders = reminder.subreminders {
            if subreminders.count > 0 {
                isParent = true
            }
        }

        return ReminderViewModelItem(completed: completed, title: title, detail: detail, priority: priority, isSubreminder: isSubreminder, hasSubreminders: isParent)
    }

    private func updateIndices() {
        var count = reminders.count
        for reminder in reminders {
            count -= 1
            reminder.index = Int16(count)
        }
    }

    // TODO: Remove this test function
    func checkReminders() {

        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var fetchedReminders: [Reminder]

        do {
            fetchedReminders = try context.fetch(fetchRequest)
            for reminder in fetchedReminders {
                print("Reminder:", reminder.title, "Completed:", reminder.completed, "isSub:", reminder.isSubreminder)
            }

        } catch {
            print("Could not fetch:", error)
        }
    }
}













