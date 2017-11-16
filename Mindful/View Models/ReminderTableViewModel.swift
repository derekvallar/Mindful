//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/4/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

protocol ReminderTableViewModelDelegate {
    func synchronized()
}

class ReminderTableViewModel {

    static let standard = ReminderTableViewModel()

    var delegate: ReminderTableViewModelDelegate?
    var reminders: [Reminder]!
    var sortingStyle: SortingStyle!

    private init() {
        print("init ReminderViewModel.shared")

        self.initializeTableData()
        sortingStyle = SortingStyle(rawValue: UserDefaults.standard.integer(forKey: "SortingStyleKey"))

        if reminders.count == 0 {
            addBlankReminder()
        }
    }

    func getReminderCount() -> Int {
        return reminders.count
    }

    func getTitle(forIndexPath indexPath: IndexPath) -> String {
        let reminder = getReminder(forIndexPath: indexPath)
        return reminder.title ?? ""
    }

    func getDetail(forIndexPath indexPath: IndexPath) -> String {
        let reminder = getReminder(forIndexPath: indexPath)

        if let alarmDate = reminder.alarmDate as Date? {
            return "Found alarm date"
        }

        guard let creationDate = reminder.creationDate as Date? else {
            return "Error: Cannot find reminder detail"
        }

        return self.creationString(creationDate)
    }

    func addBlankReminder() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not find App Delegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext

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

    func updateReminder(withTitle title: String?, detail: String?, priority: Priority?, indexPath: IndexPath) {
        let reminder = getReminder(forIndexPath: indexPath)

        if title != nil {
            reminder.title = title
        }

        if detail != nil {
            reminder.detail = detail
        }

        if priority != nil {
            reminder.priority = Int16(priority!.rawValue)
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not find App Delegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
    }


    func deleteReminders(atIndices indices: [IndexPath]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        var deletionReminders = [Reminder]()

        for indexPath in indices {
            let reminder = reminders[indexPath.row]
            deletionReminders.append(reminder)
            context.delete(reminder)
        }

        for reminder in deletionReminders {
            if let index = reminders.index(of: reminder) {
                reminders.remove(at: index)
            }
        }

        updateIndices()

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }

        deletionReminders.removeAll()
    }

    func detailedReminderViewModelForIndexPath(_ indexPath: IndexPath) -> DetailedReminderViewModel {
        let reminder = getReminder(forIndexPath: indexPath)
        let viewModel = DetailedReminderViewModel(reminder: reminder)
        return viewModel
    }


    // TODO: Remove this test function
    func checkReminders() {
        for reminder in reminders {
            print("Title:", reminder.title)
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

    private func initializeTableData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.sortedFetchRequest
        var fetchedReminders: [Reminder]

        // TODO: Remove this once reminder deletion in place

        //        do {
        //            fetchedReminders = try context.fetch(fetchRequest)
        //            for reminder in fetchedReminders {
        //                context.delete(reminder)
        //            }
        //            try context.save()
        //        } catch {
        //            print("Could not fetch:", error)
        //            return
        //        }

        do {
            fetchedReminders = try context.fetch(fetchRequest)
        } catch {
            print("Could not fetch:", error)
            return
        }

        self.reminders = fetchedReminders
        delegate?.synchronized()

        print("Reminder Count:", self.reminders.count)

//
//        for test in fetchedReminders {
//            print("Title:", test.title, "Creation:", test.creationDate)
//        }
    }


//    func sortReminders(byStyle style: SortingStyle)  {
//        switch style {
//        case .Priority:
//            reminders.sort { a, b in
//                if a.priority > b.priority {
//                    return true
//                } else if a.priority < b.priority {
//                    return false
//                } else {
//                    if a.alarmDate != nil && b.alarmDate != nil {
//                        return a.alarmDate! > b.alarmDate!
//                    } else if a.alarmDate != nil {
//                        return true
//                    } else if b.alarmDate != nil {
//                        return false
//                    } else {
//                        return a.creationDate > b.creationDate
//                    }
//                }
//            }
//
//        case .Date:
//            reminders.sort { a, b in
//                if a.alarmDate != nil && b.alarmDate != nil {
//                    return a.alarmDate! > b.alarmDate!
//                } else if a.alarmDate != nil {
//                    return true
//                } else if b.alarmDate != nil {
//                    return false
//                } else {
//                    return a.creationDate > b.creationDate
//                }
//            }
//        }
//    }
}













