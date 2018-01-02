//
//  MainReminderViewController+ReminderDelegates.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/26/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIReminderCellDelegate {
    func didTapButton(_ cell: UIReminderCell, button: UIReminderButtonType) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        switch button {
        case .complete:
            reminderViewModel.updateReminder(completed: cell.isCompleted(), title: nil, detail: nil, priority: nil, indexPath: indexPath)

        case .delete:
            reminderViewModel.deleteReminder(atIndexPath: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

        default:
            break
        }
    }
}

extension MainReminderViewController: UIReminderHeaderViewDelegate {
    func didTapButton(type: UIReminderButtonType) {
        if type == .complete {
            guard let headerView = tableView.headerView(forSection: 0) as? UIReminderHeaderView else {
                return
            }
            reminderViewModel.updateParentReminder(completed: headerView.isCompleted())
        }
    }
}
