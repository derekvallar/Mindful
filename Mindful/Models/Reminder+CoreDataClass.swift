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

    func setup(_ title: String, index: Int, priority: Int, creationDate: Date) {
        self.title = title
        self.index = Int16(index)
        self.priority = Int16(priority)
        self.creationDate = creationDate as NSDate
    }
}
