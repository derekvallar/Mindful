//
//  MainReminderViewController+UserNotifications.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit
import UserNotifications

extension MainReminderViewController {
    func createNotificationForSelectedReminder() {
        print("Creating Notification")

        guard let selectedIndex = self.indices.getSelected(),
            let actionIndex = self.indices.getAction(),
            let cell = self.tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
                return
        }
        let date = cell.getAlarmDate()

        DispatchQueue.global(qos: .background).sync {
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let uniqueIDString = UUID().uuidString

            reminder.alarmDate = date as NSDate
            reminder.alarmID = uniqueIDString
            self.viewmodel.saveReminders()

            self.updateNotifications()
            print("Done with background thread")
        }
    }

    func removeNotifictionOfSelectedReminder() {
        print("Removing Notification")

        DispatchQueue.global(qos: .background).sync {
            guard let selectedIndex = self.indices.getSelected() else {
                return
            }

            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            if let alarmString = reminder.alarmID {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [alarmString])
            }
            reminder.alarmDate = nil
            reminder.alarmID = nil
            self.viewmodel.saveReminders()
            print("Removed")

            self.updateNotifications()
        }
    }

    func updateNotifications() {
        guard let reminders = viewmodel.getAlarmReminders() else {
            return
        }

        let center = UNUserNotificationCenter.current()
        var badgeCount = 1

        center.removeAllPendingNotificationRequests()

        for reminder in reminders {
            guard let date = reminder.alarmDate,
                  let uniqueIDString = reminder.alarmID else {
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = reminder.title
            content.body = reminder.detail
            content.sound = UNNotificationSound.default()
            content.badge = badgeCount as NSNumber
            badgeCount += 1

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: uniqueIDString, content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }

        center.getPendingNotificationRequests { (requests) in
            print("Pending yes:", requests.count)
            for request in requests {
                print("Pending request")
                print((request.trigger as? UNCalendarNotificationTrigger)?.dateComponents)
            }
        }
    }
}
