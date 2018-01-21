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
            navigationItem.title = .editTitle
            let reminderCell = tableView.cellForRow(at: selectedIndex) as! UIReminderCell
            reminderCell.setUserInteraction(true)
            reminderCell.titleViewBecomeFirstResponder()
            reminderCell.editMode(true)
            mode.action = .edit
            setActionRow()

        case .priority:
            navigationItem.title = .priorityTitle
            mode.action = .priority
            setActionRow()

        case .alarm:
            navigationItem.title = .alarmTitle
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
            navigationItem.title = .subreminderTitle
            indices.setReturn()
            tableView(tableView, didDeselectRowAt: selectedIndex)
            mode.oldReminder = mode.reminder
            mode.reminder = .subreminders
            mode.action = .none

            if mode.oldReminder == .completed {
                navigationItem.setRightBarButtonItems([], animated: true)
            } else {
                navigationItem.setRightBarButtonItems([addButton], animated: true)
            }

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
            closeReminderAction()

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

