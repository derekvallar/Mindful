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
            removeNotifictionOfSelectedReminder()

        case .alarmOn:
            print("Alarm On")
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            guard let actionIndex = indices.getAction(),
                  let cell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
                return
            }
            let date = cell.getAlarmDate()
            createNotificationForSelectedReminder(withDate: date)

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension MainReminderViewController: UIEditCellTextDelegate {
    func detailTextDidEndEditing(_ cell: UIEditCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: indexPath)
        reminder.detail = cell.getDetailText()
        viewmodel.saveReminders()
    }
}

extension MainReminderViewController: UIAlarmCellDelegate {
    func alarmDateSelected(_ cell: UIAlarmCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let date = cell.getAlarmDate()
        removeNotifictionOfSelectedReminder()
        createNotificationForSelectedReminder(withDate: date)
    }
}
