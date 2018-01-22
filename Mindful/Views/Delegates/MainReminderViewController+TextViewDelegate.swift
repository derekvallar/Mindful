//
//  MainReminderViewController+TextViewDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/29/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIReminderCellTextDelegate {
    func titleTextDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            if mode.reminder == .main {
                navigationItem.setRightBarButtonItems([completedButton], animated: true)
            } else if mode.reminder == .subreminders  {
                navigationItem.setRightBarButtonItems([], animated: true)
            }
        } else {
            if mode.reminder == .main {
                navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)
            } else if mode.reminder == .subreminders  {
                navigationItem.setRightBarButtonItems([addButton], animated: true)
            }
        }

        print("textviewdidchaange")
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }

    func titleTextDidEndEditing(_ cell: UIReminderCell) {
        print("didendediting")
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let editedTitle = cell.getTitleText().replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)

        if mode.creatingReminder && editedTitle.isEmpty {
            viewmodel.deleteReminder(atIndexPath: selectedIndex)
            tableView.beginUpdates()
            tableView.deleteRows(at: [selectedIndex], with: .fade)
            tableView.endUpdates()

            if mode.reminder == .main {
                navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)
            } else if mode.reminder == .subreminders  {
                navigationItem.setRightBarButtonItems([addButton], animated: true)
            }
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        if editedTitle.isEmpty {
            cell.setTitleText(text: reminder.title)
        } else {
            reminder.title = editedTitle
            cell.setTitleText(text: editedTitle)
            viewmodel.saveReminders()
        }
    }
}
