//
//  MainReminderViewController+ActionButtons.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/20/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIActionCellDelegate {
    func didTapButton(cell: UIActionCell, type: UIReminderButtonType) {

        print("Switching to:", type)
        guard let selectedReminder = selectedReminder else {
            return
        }

        switch type {
        case .edit:
            let reminderCell = tableView.cellForRow(at: selectedReminder) as! UIReminderCell
            reminderCell.titleTextView.isUserInteractionEnabled = true
            currentMode = .editReminder

            let deadlineTime = DispatchTime.now() + .milliseconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
            }

        case .priority:
            currentMode = .editPriority
            let deadlineTime = DispatchTime.now() + .milliseconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
            }

        case .lowPriority:
            print("low priority")
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.low, indexPath: selectedReminder)

        case .mediumPriority:
            print("Medium priority")
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.medium, indexPath: selectedReminder)

        case .highPriority:
            print("high priority")
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.high, indexPath: selectedReminder)

        case .alarm:
            currentMode = .editAlarm
            print("ActionCellIndex:", getActionCellIndex())

            // TODO: Currently scrolltoRow doesn't work w/o a delay. Find a fix in future iOS updates.
            let deadlineTime = DispatchTime.now() + .milliseconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
            }
            break

        case .addSubreminder:
            break

        case .returnAction:
            if currentMode == .editReminder {
                guard let selectedCell = tableView.cellForRow(at: selectedReminder) as? UIReminderCell else {
                    return
                }

                selectedCell.titleTextView.isUserInteractionEnabled = false

                viewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: selectedReminder)
            } else if currentMode == .editAlarm {
                print("Date:", cell.getAlarmDate())
                viewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: selectedReminder)
            }

            print("Returning with selected:", selectedReminder != nil)
            tableView.reloadRows(at: [selectedReminder], with: .none)
            tableView.selectRow(at: selectedReminder, animated: true, scrollPosition: .none)

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
