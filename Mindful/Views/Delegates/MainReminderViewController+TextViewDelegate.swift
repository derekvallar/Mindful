//
//  MainReminderViewController+TextViewDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/29/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("TextViewDidEndEditing")

        let textViewPoint = textView.convert(textView.center, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint) else {
                return
        }

        if let cell = tableView.cellForRow(at: indexPath) as? UIReminderCell {
            let reminder = viewmodel.getReminder(forIndexPath: indexPath)
            reminder.title = cell.getTitleText()
            viewmodel.saveReminders()
            return
        }

        if let cell = tableView.cellForRow(at: indexPath) as? UIEditCell {
            let reminder = viewmodel.getReminder(forIndexPath: indexPath)
            reminder.detail = cell.getDetailText()
            viewmodel.saveReminders()
            return
        }
    }
}

extension MainReminderViewController: UIReminderCellTextDelegate {
    func titleTextDidEndEditing(_ cell: UIReminderCell) {
        guard let selectedIndex = indices.getSelected() else {
            return
        }

        let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
        reminder.title = cell.getTitleText()
        viewmodel.saveReminders()
    }
}
