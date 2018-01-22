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
        print("closingreminder")
        view.endEditing(true)
        if let selectedIndex = indices.getSelected() {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }

        if mode.creatingReminder {
            indices.clearSelected()
            mode.creatingReminder = false
            return
        }

        closeReminderAction()

        guard let categoryIndex = indices.getCategory(),
              let categoryCell = tableView.cellForRow(at: categoryIndex) as? UICategoryCell else {
            return
        }

        print("closing cat")
        categoryCell.animateHideCategories(withSubreminder: true)

        indices.clearSelected()
        tableView.beginUpdates()
        tableView.deleteRows(at: [categoryIndex], with: .automatic)
        tableView.endUpdates()
    }

    func closeReminderAction() {
        guard let actionIndex = indices.getAction() else {
            return
        }
        print("closing action")

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

        indices.clearAction()
        tableView.beginUpdates()
        tableView.deleteRows(at: [actionIndex], with: .automatic)
        tableView.endUpdates()
    }
}
