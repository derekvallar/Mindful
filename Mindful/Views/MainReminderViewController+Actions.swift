//
//  MainReminderViewController+Actions.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/20/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIActionCellDelegate {
    func didTapButton(cell: UIActionCell, type: UIReminderButtonType) {

        switch type {
        case .edit:
            currentMode = .editReminder
            break

        case .priority:
            break

        case .alarm:
            currentMode = .editAlarm
            break

        case .addSubreminder:
            break

        case .returnAction:
            if currentMode == .editReminder {
                guard let index = tableView.indexPathForSelectedRow,
                      let selectedCell = tableView.cellForRow(at: index) as? UIReminderCell else {
                    return
                }

                print("Detail:", cell.getDetailText())
                viewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: index)
            } else if currentMode == .editAlarm {
                guard let index = tableView.indexPathForSelectedRow else {
                    return
                }
                print("Date:", cell.getAlarmDate())
                viewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: index)
            }

            currentMode = .main

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
