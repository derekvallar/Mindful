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

    func getTitle(forIndex index: Int) -> String {
        return reminders[index].title ?? ""
    }

    func getDetail(forIndex index: Int) -> String {
        

        return reminders![index].creationDate!.description(with: Locale.current)
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

    func updateReminder(withTitle title: String, indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]
        print("Oldtitle:", reminder.title, "NewTitle:", title)
        reminder.title = title

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


        for test in fetchedReminders {
            print("Title:", test.title, "Creation:", test.creationDate)
        }
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













