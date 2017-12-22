//
//  Reminder+CoreDataProperties.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/22/17.
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
    @NSManaged public var isSubreminder: Bool
    @NSManaged public var subreminders: NSSet?

}

// MARK: Generated accessors for subreminders
extension Reminder {

    @objc(addSubremindersObject:)
    @NSManaged public func addToSubreminders(_ value: Reminder)

    @objc(removeSubremindersObject:)
    @NSManaged public func removeFromSubreminders(_ value: Reminder)

    @objc(addSubreminders:)
    @NSManaged public func addToSubreminders(_ values: NSSet)

    @objc(removeSubreminders:)
    @NSManaged public func removeFromSubreminders(_ values: NSSet)

}
