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
        let textViewPoint = textView.convert(textView.center, to: tableView)

        guard let indexPath = tableView.indexPathForRow(at: textViewPoint),
            let cell = tableView.cellForRow(at: indexPath) as? UIReminderCell else {
                return
        }

        let item = ReminderViewModelSaveItem()
        item.title = cell.getTitleText()
        viewmodel.updateReminder(item: item, indexPath: indexPath)
    }
}
