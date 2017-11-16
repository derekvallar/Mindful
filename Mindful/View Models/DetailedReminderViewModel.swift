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

    public func updateTitle(_ title: String) {
        reminder.title = title

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





