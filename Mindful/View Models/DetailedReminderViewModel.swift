//
//  CreateReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/8/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

class DetailedReminderViewModel {

    var reminder: Reminder!

    public init(reminder: Reminder) {
        self.reminder = reminder
    }

    public func getTitle() -> String {
        return reminder.title!
    }

    public func getDetail() -> String {
        return reminder.detail ?? ""
    }

    public func getPriority() -> Priority {
        let priority = reminder.priority
        return Priority(rawValue: priority)!
    }

    public func updateReminder(title: String, detail: String, priority: Priority) {
        var hasChanges = false

        if reminder.title != title {
            reminder.title = title
            hasChanges = true
        }

        if reminder.detail != detail {
            reminder.detail = detail
            hasChanges = true
        }

        let int16Priority = Int16(priority.rawValue)
        if reminder.priority != int16Priority {
            reminder.priority = int16Priority
            hasChanges = true
        }

        if hasChanges {
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
    }
}





