//
//  MainReminderViewController+ReminderDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/26/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIReminderCellDelegate {
    
    func didTapReminderButton(_ cell: UIReminderCell, type: UIReminderButtonType) {
        guard let indexPath = tableView.indexPath(for: cell),
              case let .reminder(type) = type else {
            return
        }

        switch type {
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
