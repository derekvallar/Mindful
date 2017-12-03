//
//  Reminder+CoreDataProperties.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/1/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var alarmDate: NSDate?
    @NSManaged public var completed: Bool
    @NSManaged public var completedDate: NSDate?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var detail: String?
    @NSManaged public var index: Int16
    @NSManaged public var priority: Int16
    @NSManaged public var title: String?
    @NSManaged public var subreminder: Bool
    @NSManaged public var subReminders: NSSet?

}

// MARK: Generated accessors for subReminders
extension Reminder {

    @objc(addSubRemindersObject:)
    @NSManaged public func addToSubReminders(_ value: Reminder)

    @objc(removeSubRemindersObject:)
    @NSManaged public func removeFromSubReminders(_ value: Reminder)

    @objc(addSubReminders:)
    @NSManaged public func addToSubReminders(_ values: NSSet)

    @objc(removeSubReminders:)
    @NSManaged public func removeFromSubReminders(_ values: NSSet)

}
