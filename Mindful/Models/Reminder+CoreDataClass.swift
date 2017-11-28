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

    func setup(_ title: String, index: Int, priority: Int16, creationDate: Date) {
        self.title = title
        self.index = Int16(index)
        self.priority = priority
        self.creationDate = creationDate as NSDate

        self.completed = false
        self.detail = String()
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

        request.sortDescriptors = [indexSort]
        request.predicate = completedPredicate
        return request
    }
}
