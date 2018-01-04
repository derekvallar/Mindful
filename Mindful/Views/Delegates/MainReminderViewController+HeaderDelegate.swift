//
//  MainReminderViewController+HeaderDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

extension MainReminderViewController: UIReminderHeaderViewDelegate {
    func didTapHeaderButton(type: UIReminderButtonType) {
        guard case let .reminder(type) = type else {
            return
        }

        if type == .complete {
            guard let headerView = tableView.headerView(forSection: 0) as? UIReminderHeaderView else {
                return
            }
            viewmodel.updateParentReminder(completed: headerView.isCompleted())
        }
    }
}
