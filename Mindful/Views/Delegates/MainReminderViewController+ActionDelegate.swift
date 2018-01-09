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
            let item = ReminderViewModelSaveItem()
            item.priority = Priority.low
            viewmodel.updateReminder(item: item, indexPath: selectedIndex)

        case .mediumPriority:
            let item = ReminderViewModelSaveItem()
            item.priority = Priority.medium
            viewmodel.updateReminder(item: item, indexPath: selectedIndex)

        case .highPriority:
            let item = ReminderViewModelSaveItem()
            item.priority = Priority.high
            viewmodel.updateReminder(item: item, indexPath: selectedIndex)

        case .alarmButton:
            scrollIndexToMiddleIfNeeded(indices.getAction())

        case .alarmOff:
            deleteNotifictionOfSelectedReminder()

        case .alarmOn:
            let item = ReminderViewModelSaveItem()
            guard let actionIndex = indices.getAction(),
                let cell = tableView.cellForRow(at: actionIndex) as? UIAlarmCell else {
                    return
            }
            item.alarm = cell.getAlarmDate()
            viewmodel.updateReminder(item: item, indexPath: selectedIndex)
            createNotificationFromSelectedReminder()

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
