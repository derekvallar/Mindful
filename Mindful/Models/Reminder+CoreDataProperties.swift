//
//  Reminder+CoreDataProperties.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/22/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var completedDate: NSDate?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var detail: String?
    @NSManaged public var index: Int16
    @NSManaged public var priority: Int16
    @NSManaged public var alarmDate: NSDate?
    @NSManaged public var title: String?

}
