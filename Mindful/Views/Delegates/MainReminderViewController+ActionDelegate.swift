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
            viewmodel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.low, indexPath: selectedIndex)

        case .mediumPriority:
            viewmodel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.medium, indexPath: selectedIndex)

        case .highPriority:
            viewmodel.updateReminder(completed: nil, title: nil, detail: nil, priority: Priority.high, indexPath: selectedIndex)

        case .alarmLabel:
            scrollIndexToMiddleIfNeeded(indices.getAction())

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
