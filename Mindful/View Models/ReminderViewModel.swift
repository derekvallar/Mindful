//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/4/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class ReminderViewModel: ReminderViewModelProtocol {

    var context: NSManagedObjectContext
    var reminders: [Reminder]
    var parentReminder: Reminder?

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        reminders = [Reminder]()

        initializeTableData(withCompleted: false, completion: nil)
//        checkReminders()
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

    func initializeSubreminders(ofIndexPath index: IndexPath, completion: ((_ result: Bool) -> Void)?) {
        self.parentReminder = getReminder(forIndexPath: index)

        guard let subreminderSet = reminder.subreminders else {
            completion?(false)
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
        completion?(true)

        for item in reminders {
            print("Sub", item.index, ", completed:", item.completed, ", title:", item.title)
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













