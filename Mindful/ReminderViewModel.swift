//
//  ReminderViewModel.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/4/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import CoreData

protocol ReminderViewModelDelegate {
    func synchronized()
}

class ReminderViewModel {

    static let shared = ReminderViewModel()
    var delegate: ReminderViewModelDelegate?
    var reminders: [Reminder]!

    private init() {}

    func synchronize() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        var entities: [ReminderEntity]

        do {
            entities = try context.fetch(fetchRequest)
        } catch {
            print("Could not fetch:", error)
            return
        }

        var reminders = [Reminder]()
        for entity in entities {
            let reminder = Reminder(entity: entity)
            reminders.append(reminder)
        }
        self.reminders = reminders

        delegate?.synchronized()
   }

    func getReminderCount() -> Int {
        return reminders.count
    }

    func getTitle(forIndex index: Int) -> String {
        return reminders![index].title!
    }

    func getCreationDate(forIndex index: Int) -> String {
        return reminders![index].creationDate!.description(with: Locale.current)
    }

    func getRemindDate(forIndex index: Int) -> String {
        return reminders![index].remindDate!.description(with: Locale.current)
    }
}
