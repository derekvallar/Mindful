//
//  Reminder+CoreDataClass.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/22/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reminder)
public class Reminder: NSManagedObject {

    func setup(index: Int, subreminder: Bool) {
        self.title = ""
        self.detail = ""
        self.index = Int16(index)
        self.priority = Priority.low.rawValue
        self.isSubreminder = subreminder
    }

    func hasSubreminders() -> Bool {
        if let count = subreminders?.count, count > 0 {
            return true
        }
        return false
    }

    static func sortedFetchRequest(withCompleted completed: Bool) -> NSFetchRequest<Reminder> {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        let indexSort: NSSortDescriptor!

        if completed {
            indexSort = NSSortDescriptor(key: "completedDate", ascending: false)
        } else {
            indexSort = NSSortDescriptor(key: "index", ascending: false)
        }

        let completedPredicate = NSPredicate(format: "completed == %@", NSNumber(value: completed))
        let subreminderPredicate = NSPredicate(format: "isSubreminder == %@", NSNumber(value: false))
        let requestPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completedPredicate, subreminderPredicate])

        request.sortDescriptors = [indexSort]
        request.predicate = requestPredicate
        return request
    }

    static func alarmFetchRequest() -> NSFetchRequest<Reminder> {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()

        let alarm = NSSortDescriptor(key: "alarmDate", ascending: true)
        let alarmPredicate = NSPredicate(format: "alarmDate != nil")
        let alarmStringPredicate = NSPredicate(format: "alarmID != nil")
        let uncompletedPredicate = NSPredicate(format: "completed == %@", NSNumber(value: false))
        let requestPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [alarmPredicate, alarmStringPredicate, uncompletedPredicate])

        request.sortDescriptors = [alarm]
        request.predicate = requestPredicate
        return request
    }
}
