//
//  MainReminderViewController+ActionDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/20/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIActionCellDelegate {
    func didTapActionButton(type: UIReminderButtonType) {
        guard let selectedIndex = indices.getSelected(),
              case let .action(type) = type else {
            return
        }

        switch type {
        case .lowPriority:
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            reminder.priority = Priority.low.rawValue
            viewmodel.saveReminders()

        case .mediumPriority:
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            reminder.priority = Priority.medium.rawValue
            viewmodel.saveReminders()

        case .highPriority:
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            reminder.priority = Priority.high.rawValue
            viewmodel.saveReminders()

        case .alarmButton:
            scrollIndexToMiddleIfNeeded(indices.getAction())

        case .alarmOff:
            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }

            guard let id = reminder.alarmID else {
                return
            }
            reminder.alarmDate = nil
            reminder.alarmID = nil

            DispatchQueue.global(qos: .background).async {
                self.viewmodel.saveReminders()
                self.removeNotification(withIdentifier: id)
            }

        case .alarmOn:
            guard let actionIndex = indices.getAction(),
                  let alarmCell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
                return
            }

            let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
            let uniqueIDString = UUID().uuidString
            let date = alarmCell.getAlarmDate()

            reminder.alarmDate = date as NSDate
            reminder.alarmID = uniqueIDString
            self.viewmodel.saveReminders()

            DispatchQueue.global(qos: .background).async {
                self.updateNotifications()
            }

            if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                UIApplication.shared.applicationIconBadgeNumber += 1
            }

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension MainReminderViewController: UIEditCellTextDelegate {
    func detailTextDidEndEditing(_ cell: UIEditCell) {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        reminder.detail = cell.getDetailText()
        viewmodel.saveReminders()

        guard let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
            return
        }
        selectedCell.setDetailText(text: reminder.detail)
    }
}

extension MainReminderViewController: UIAlarmCellDelegate {
    func alarmDateSelected(_ cell: UIAlarmCell) {
        let date = cell.getAlarmDate()

        guard let selectedIndex = self.indices.getSelected() else {
            return
        }

        let reminder = self.viewmodel.getReminder(forIndexPath: selectedIndex)
        guard let id = reminder.alarmID else {
            return
        }

        if !reminder.completed, let oldDate = reminder.alarmDate as Date?, oldDate < Date() {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }

        reminder.alarmDate = date as NSDate
        self.viewmodel.saveReminders()

        DispatchQueue.global(qos: .background).async {
            self.removeNotification(withIdentifier: id)
            self.updateNotifications()
        }

        if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
}
