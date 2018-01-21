//
//  MainReminderViewController+ModeHandling.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/20/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

extension MainReminderViewController {
    func closeReminder() {
        view.endEditing(true)
        if let selectedIndex = indices.getSelected() {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }

        closeReminderAction()

        guard let categoryIndex = indices.getCategory(),
              let categoryCell = tableView.cellForRow(at: categoryIndex) as? UICategoryCell else {
            return
        }
        categoryCell.animateHideCategories(withSubreminder: true)

        indices.clearSelected()
        mode.action = .none

        tableView.beginUpdates()
        tableView.deleteRows(at: [categoryIndex], with: .automatic)
        tableView.endUpdates()
    }

    func closeReminderAction() {
        if mode.action == .none {
            return
        }

        if mode.action == .edit {
            guard let selectedIndex = indices.getSelected(),
                  let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                return
            }
            selectedCell.setUserInteraction(false)
            selectedCell.editMode(false)
        }

        mode.action = .none

        if mode.reminder == .main {
            navigationItem.title = .mainTitle
        } else if mode.reminder == .completed {
            navigationItem.title = .completedTitle
        } else if mode.reminder == .subreminders {
            navigationItem.title = .subreminderTitle
        }

        tableView.beginUpdates()
        if let actionIndex = indices.getAction() {
            tableView.deleteRows(at: [actionIndex], with: .automatic)
            indices.clearAction()
        }
        tableView.endUpdates()
    }
}
