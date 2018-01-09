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

        let item = viewmodel.getReminderItem(forIndexPath: selectedIndex)
        let content = UNMutableNotificationContent()
        let userdefaults = UserDefaults.standard
        var badgeCount = userdefaults.integer(forKey: .alarmBadgeCountString)
        badgeCount += 1

        content.title = item.title
        content.body = item.detail
        content.sound = UNNotificationSound.default()
        content.badge = badgeCount as NSNumber

        guard let alarmDate = item.alarm else {
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
            let saveItem = ReminderViewModelSaveItem()
            saveItem.alarmString = uniqueIDString
            self.viewmodel.updateReminder(item: saveItem, indexPath: selectedIndex)
        }
    }

    func deleteNotifictionOfSelectedReminder() {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let item = viewmodel.getReminderItem(forIndexPath: selectedIndex)
        if let alarmString = item.alarmString {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [alarmString])
        }

        let item = ReminderViewModelSaveItem()
        item.alarm = nil
        ite
        viewmodel.updateReminder(item: item, indexPath: selectedIndex)
    }

    func recreateNotificationOfSelectedReminder() {
        deleteNotifictionOfSelectedReminder()
        createNotificationFromSelectedReminder()
    }
}
