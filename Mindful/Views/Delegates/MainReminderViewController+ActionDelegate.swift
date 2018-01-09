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
            deleteNotifictionOfSelectedReminder()

        case .alarmOn:
            let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
            guard let actionIndex = indices.getAction(),
                let cell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
                    return
            }
            reminder.alarmDate = cell.getAlarmDate() as NSDate
            viewmodel.saveReminders()
            createNotificationFromSelectedReminder()

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
