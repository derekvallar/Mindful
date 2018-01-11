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
            print("Alarm Off")
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
            removeNotifictionOfSelectedReminder()

        case .alarmOn:
            print("Alarm On")
            createNotificationForSelectedReminder()
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
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
        print("Set detail")
    }
}

extension MainReminderViewController: UIAlarmCellDelegate {
    func alarmDateSelected(_ cell: UIAlarmCell) {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }

        removeNotifictionOfSelectedReminder()
        createNotificationForSelectedReminder()

        if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
}
