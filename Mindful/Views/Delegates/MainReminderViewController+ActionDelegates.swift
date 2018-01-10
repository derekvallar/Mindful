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
        print("New Alarm Selected")
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let date = cell.getAlarmDate()
        removeNotifictionOfSelectedReminder()
        createNotificationForSelectedReminder(withDate: date)
    }
}
