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
            currentMode = .editReminder
            break

        case .priority:
            currentMode = .editPriority
            break

        case .lowPriority:
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.low, indexPath: selectedReminder)

        case .mediumPriority:
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.medium, indexPath: selectedReminder)

        case .highPriority:
            viewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.high, indexPath: selectedReminder)

        case .alarm:
            currentMode = .editAlarm
            break

        case .addSubreminder:
            break

        case .returnAction:
            guard let index = tableView.indexPathForSelectedRow else {
                return
            }

            if currentMode == .editReminder {
                guard let selectedCell = tableView.cellForRow(at: index) as? UIReminderCell else {
                    return
                }

                viewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: index)
            } else if currentMode == .editAlarm {
                print("Date:", cell.getAlarmDate())
                viewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: index)
            }

            print("Returning with selected:", tableView.indexPathForSelectedRow != nil)
            tableView.reloadRows(at: [index], with: .none)
            tableView.selectRow(at: index, animated: true, scrollPosition: .none)

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
