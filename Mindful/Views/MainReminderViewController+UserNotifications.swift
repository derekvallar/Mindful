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

    func removeNotification(withIdentifier id: String) {
        print("Removing Notification")

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
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
            print("Pending requests:", requests.count)
            for request in requests {
                print((request.trigger as? UNCalendarNotificationTrigger)?.dateComponents)
            }
        }

        center.getDeliveredNotifications { (requests) in
            print("Delivered requests:", requests.count)
            for request in requests {
                print(request.request.content.title)
            }
        }
    }
}
