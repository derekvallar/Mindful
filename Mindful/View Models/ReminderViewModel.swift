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

    static let standard = ReminderViewModel()

    var delegate: ReminderViewModelDelegate?
    var reminders: [Reminder]!
    var sortingStyle: SortingStyle!

    private init() {
        print("init RemidnerViewModel.shared")

        synchronize()
        sortingStyle = SortingStyle(rawValue: UserDefaults.standard.integer(forKey: "SortingStyleKey"))
    }

    func synchronize() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ReminderEntity> = ReminderEntity.fetchRequest()
        var entities: [ReminderEntity]

        do {
            entities = try context.fetch(fetchRequest)
            print("Entities1: ", entities)
        } catch {
            print("Could not fetch:", error)
            return
        }

        print("Entities2: ", entities)

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
        return reminders![index].title
    }

    func getDetail(forIndex index: Int) -> String {
        return reminders![index].creationDate.description(with: Locale.current)
    }

    func sortReminders(byStyle style: SortingStyle)  {
        switch style {
        case .Priority:
            reminders.sort { a, b in
                if a.priority.rawValue > b.priority.rawValue {
                    return true
                } else if a.priority.rawValue < b.priority.rawValue {
                    return false
                } else {
                    if a.alarmDate != nil && b.alarmDate != nil {
                        return a.alarmDate! > b.alarmDate!
                    } else if a.alarmDate != nil {
                        return true
                    } else if b.alarmDate != nil {
                        return false
                    } else {
                        return a.creationDate > b.creationDate
                    }
                }
            }

        case .Date:
            reminders.sort { a, b in
                if a.alarmDate != nil && b.alarmDate != nil {
                    return a.alarmDate! > b.alarmDate!
                } else if a.alarmDate != nil {
                    return true
                } else if b.alarmDate != nil {
                    return false
                } else {
                    return a.creationDate > b.creationDate
                }
            }
        }
    }
}













