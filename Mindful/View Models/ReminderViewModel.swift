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

    static let standard = ReminderViewModel()

//    var selectedIndexPath: IndexPath!
//    var parentIndexPath: IndexPath!

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        reminders = [Reminder]()

        initializeTableData(withCompleted: false, completion: nil)
//        checkReminders()
    }

    func addReminder() {
        let reminder = Reminder(context: context)
        let nextIndex = reminders.count

        reminder.setup(index: nextIndex, subreminder: false)
        reminders.insert(reminder, at: 0)

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

    func getSubreminderViewModelForIndexPath(_ indexPath: IndexPath) -> SubreminderViewModel {
        let reminder = getReminder(forIndexPath: indexPath)
        let viewModel = SubreminderViewModel(reminder)
        return viewModel
    }

    func hasSubreminders(indexPath: IndexPath) -> Bool {
        let reminder = getReminder(forIndexPath: indexPath)
        if let subreminders = reminder.subreminders {
            if subreminders.count > 0 {
                return true
            }
        }
        return false
    }

//    func reminderDeselected(indexPath: IndexPath) -> [IndexPath] {
//        var indices = getSubreminderIndices()
//        subreminders.removeAll()
//        return indices
//    }

//    func moveReminder(fromIndex start: IndexPath, toIndex end: IndexPath) {
//        let reminder = getReminder(forIndexPath: start)
//
//        guard let index = reminders.index(of: reminder) else {
//            return
//        }
//
//        reminders.remove(at: index)
//        reminders.insert(reminder, at: end.row)
//    }

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

}













