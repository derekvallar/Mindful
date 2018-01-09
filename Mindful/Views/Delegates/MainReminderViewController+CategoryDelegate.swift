//
//  MainReminderViewController+CategoryDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation
import UserNotifications

extension MainReminderViewController: UICategoryCellDelegate {

    func didTapCategoryButton(type: UIReminderButtonType) {
        guard let selectedIndex = indices.getSelected(),
            case let .category(type) = type else {
                return
        }

        switch type {
        case .edit:
            let reminderCell = tableView.cellForRow(at: selectedIndex) as! UIReminderCell
            reminderCell.setUserInteraction(true)
            mode.action = .edit
            setActionRow()

        case .priority:
            mode.action = .priority
            setActionRow()

        case .alarm:
            let notifications = UNUserNotificationCenter.current()
            notifications.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if let error = error {
                    print(error)
                    return
                }

                if granted {
                    print("Request granted")
                    DispatchQueue.main.async {
                        self.mode.action = .alarm
                        self.setActionRow()
                    }
                } else {
                    print("Request denied")

                    // TODO: Add an alertview to change notification settings
                }
            })

        case .subreminders:
            indices.setReturn()
            tableView(tableView, didDeselectRowAt: selectedIndex)
            mode.reminder = .subreminders
            mode.action = .none

            navigationItem.setRightBarButtonItems([addButton], animated: true)
            viewmodel.initializeSubreminders(ofIndexPath: selectedIndex, completion: { (completed) in
                if completed {
                    print("subreminder reloading")
                    let indexSet: IndexSet = [0]
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(indexSet, with: .automatic)
                    self.tableView.endUpdates()
                }
            })

        case .back:
            if mode.action == .edit {
                guard let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                    return
                }
                selectedCell.setUserInteraction(false)
            } else if mode.action == .alarm {
            }
            mode.action = .none

            tableView.beginUpdates()
            if let actionIndex = indices.getAction() {
                tableView.deleteRows(at: [actionIndex], with: .automatic)
                indices.clearAction()
            }
            tableView.endUpdates()
            scrollIndexToMiddleIfNeeded(indices.getAction())

        default:
            break
        }
    }

    private func setActionRow() {
        tableView.beginUpdates()
        indices.setAction()
        guard let actionIndex = indices.getAction() else {
            return
        }
        tableView.insertRows(at: [actionIndex], with: .automatic)
        tableView.endUpdates()
        scrollIndexToMiddleIfNeeded(indices.getAction())
    }
}

