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
    }

    func initializeTableData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        var fetchedReminders: [Reminder]

        do {
            fetchedReminders = try context.fetch(fetchRequest)
            print("Entities1: ", fetchedReminders)
        } catch {
            print("Could not fetch:", error)
            return
        }

        print("Entities2: ", fetchedReminders)

        self.reminders = fetchedReminders

        delegate?.synchronized()
    }

//    func synchronizeCoreData() {
//
//    }

    func addReminder(withTitle title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not find App Delegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        let reminder = Reminder(context: context)
        let nextIndex = reminders[0].index + 1
        reminder.setup(title, index: nextIndex, priority: Priority.none.rawValue, creationDate: Date())

        reminders.insert(reminder, at: 0)

        do {
            try context.save()
        } catch {
            print("Error:", error)
        }
    }

    func getReminderCount() -> Int {
        return reminders.count
    }

    func getTitle(forIndex index: Int) -> String {
        return reminders[index].title!
    }

    func getDetail(forIndex index: Int) -> String {
        return reminders![index].creationDate!.description(with: Locale.current)
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













