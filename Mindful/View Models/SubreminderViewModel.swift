////
////  SubreminderViewModel.swift
////  Mindful
////
////  Created by Derek Vitaliano Vallar on 12/3/17.
////  Copyright © 2017 Derek Vallar. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class SubreminderViewModel: ReminderViewModelProtocol {
//
//    var context: NSManagedObjectContext
//    var reminders: [Reminder]
//
//    init(_ reminder: Reminder) {
//        self.reminder = reminder
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        context = appDelegate.persistentContainer.viewContext
//        reminders = [Reminder]()
//
//        initializeTableData()
//    }
//
//    func addReminder() {
//        let subreminder = Reminder(context: context)
//        let nextIndex = reminders.count
//
//        reminders.insert(subreminder, at: 0)
//        reminder.addToSubreminders(subreminder)
//
//        saveReminders()
//    }
////
////    func getSectionViewModelItem() -> ReminderViewModelItem {
////        let completed = reminder.completed
////        let title = reminder.title!
////        var detail: String?
////
////        if let creationDate = reminder.creationDate as Date? {
////            detail = creationString(creationDate)
////        }
////
////        let priority = Priority(rawValue: (reminder.priority))!
////
////        return ReminderViewModelItem(completed: completed, title: title, detail: detail, priority: priority, subreminders: subreminder)
////    }
//
//
//}

