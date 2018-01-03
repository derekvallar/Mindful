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
        guard let selectedIndex = selectedCellIndex,
              case let .action(type) = type else {
            return
        }

        switch type {
        case .lowPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.low, indexPath: selectedIndex)

        case .mediumPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.medium, indexPath: selectedIndex)

        case .highPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.high, indexPath: selectedIndex)

        case .alarmLabel:
            scrollActionCellToMiddle()

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
