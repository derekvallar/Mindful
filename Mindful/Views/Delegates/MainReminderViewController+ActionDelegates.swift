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
            guard let alarmIndex = indices.getAction(),
                  let alarmCell = tableView.cellForRow(at: alarmIndex) as? UIAlarmCell else {
                return
            }
            alarmCell.animatePicker(tableView: tableView)
            scrollIndexToMiddleIfNeeded(indices.getAction())

        case .alarmOff:
            removeAlarmFromSelectedCell()

        case .alarmOn:
            addAlarmToSelectedCell()

        }
    }
}

extension MainReminderViewController: UIEditCellTextDelegate {
    func detailTextDidChange() {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }

    func detailTextDidEndEditing(_ cell: UIEditCell) {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let editedTitle = cell.getDetailText().replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        reminder.detail = editedTitle
        viewmodel.saveReminders()

        guard let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
            return
        }
        selectedCell.setDetailText(text: editedTitle)
    }
}

extension MainReminderViewController: UIAlarmCellDelegate {
    func alarmDateSelected() {
        updateAlarmOfSelectedCell()
    }
}
