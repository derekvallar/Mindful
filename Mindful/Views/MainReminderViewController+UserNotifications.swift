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
    func createNotificationFromSelectedReminder() {
        print("Creating Notification")
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        let content = UNMutableNotificationContent()
        let userdefaults = UserDefaults.standard
        var badgeCount = userdefaults.integer(forKey: .alarmBadgeCountString)
        badgeCount += 1

        content.title = reminder.title
        content.body = reminder.detail
        content.sound = UNNotificationSound.default()
        content.badge = badgeCount as NSNumber

        guard let alarmDate = reminder.alarmDate as Date? else {
            return
        }
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmDate)
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
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            reminder.alarmString = uniqueIDString
            self.viewmodel.saveReminders()
        }
    }

    func deleteNotifictionOfSelectedReminder() {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        if let alarmString = reminder.alarmString {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [alarmString])
        }
        reminder.alarmDate = nil
        viewmodel.saveReminders()
    }

    func recreateNotificationOfSelectedReminder() {
        deleteNotifictionOfSelectedReminder()
        createNotificationFromSelectedReminder()
    }
}
