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
    func createNotificationForSelectedReminder(withDate date: Date) {
        print("Creating Notification:", date)

        DispatchQueue.global(qos: .background).async {
            guard let selectedIndex = self.indices.getSelected() else {
                return
            }

            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let content = UNMutableNotificationContent()
            let userdefaults = UserDefaults.standard
            var badgeCount = userdefaults.integer(forKey: .alarmBadgeCountString)
            badgeCount += 1

            content.title = reminder.title
            content.body = reminder.detail
            content.sound = UNNotificationSound.default()
            content.badge = badgeCount as NSNumber

            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uniqueIDString = UUID().uuidString

            let request = UNNotificationRequest(identifier: uniqueIDString, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if let error = error {
                    print(error)
                    return
                }

                print("Notification Set~!")
                reminder.alarmDate = date as NSDate
                reminder.alarmString = uniqueIDString
                self.viewmodel.saveReminders()

                center.getPendingNotificationRequests { (requests) in
                    print("Current Requests:")
                    for request in requests {
                        print(request)
                        
                    }
                }
            }
        }
    }

    func removeNotifictionOfSelectedReminder() {
        print("Removing Notification")

        DispatchQueue.global(qos: .background).async {
            guard let selectedIndex = self.indices.getSelected() else {
                return
            }

            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            if let alarmString = reminder.alarmString {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [alarmString])
            }
            reminder.alarmDate = nil
            reminder.alarmString = nil
            self.viewmodel.saveReminders()
            print("Removed")
        }
    }
}
