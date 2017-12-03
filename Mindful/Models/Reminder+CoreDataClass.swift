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
        self.completed = false
        self.subreminder = false

        self.title = String()
        self.detail = String()

        self.index = Int16(index)
        self.priority = Priority.none.rawValue
        self.creationDate = Date() as NSDate
        self.subreminder = subreminder
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
        let subreminderPredicate = NSPredicate(format: "subreminder == %@", NSNumber(value: false))
        let requestPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completedPredicate, subreminderPredicate])

        request.sortDescriptors = [indexSort]
        request.predicate = requestPredicate
        return request
    }
}
