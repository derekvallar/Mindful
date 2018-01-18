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

    func addAlarmToSelectedCell() {
        print("Adding alarms")

        guard let selectedIndex = indices.getSelected(),
              let actionIndex = indices.getAction(),
              let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell,
              let alarmCell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
            return
        }

        let date = alarmCell.getAlarmDate()

        DispatchQueue.global(qos: .background).async {
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let uniqueIDString = UUID().uuidString

            reminder.alarmDate = date as NSDate
            reminder.alarmID = uniqueIDString
            self.viewmodel.saveReminders()

            DispatchQueue.main.sync {
                UIView.animate(withDuration: 0.2, animations: {
                    selectedCell.setAlarmText(text: date.getText())
                })
                self.tableView.beginUpdates()
                self.tableView.endUpdates()

                if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                    UIApplication.shared.applicationIconBadgeNumber += 1
                }
            }

            self.updateNotifications()
        }
    }

    func removeAlarmFromSelectedCell() {
        print("Removing alarms")

        guard let selectedIndex = indices.getSelected(),
              let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
            return
        }

        DispatchQueue.global(qos: .background).async {
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let oldId = reminder.alarmID
            reminder.alarmDate = nil
            reminder.alarmID = nil

            self.viewmodel.saveReminders()

            DispatchQueue.main.sync {
                if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                }

                selectedCell.setAlarmText(text: "")
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }

            if let oldId = oldId {
                self.removeNotification(withIdentifier: oldId)
            }
        }
    }

    func updateAlarmOfSelectedCell() {
        print("Updating alarms")

        guard let selectedIndex = indices.getSelected(),
              let actionIndex = indices.getAction(),
              let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell,
              let alarmCell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
            return
        }

        let setDate = alarmCell.getAlarmDate()

        DispatchQueue.global(qos: .background).async {
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let oldDate = reminder.alarmDate as Date?
            let oldId = reminder.alarmID
            let uniqueIDString = UUID().uuidString

            reminder.alarmDate = setDate as NSDate
            reminder.alarmID = uniqueIDString

            self.viewmodel.saveReminders()

            DispatchQueue.main.sync {
                if !reminder.completed {
                    let currentDate = Date()
                    if let oldDate = oldDate, oldDate < currentDate {
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }

                    if setDate < currentDate {
                        UIApplication.shared.applicationIconBadgeNumber += 1
                    }
                    
                    selectedCell.setAlarmText(text: "")
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }

            if let id = oldId {
                self.removeNotification(withIdentifier: id)
            }
            self.updateNotifications()
        }
    }

    private func removeNotification(withIdentifier id: String) {
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
    }
}
