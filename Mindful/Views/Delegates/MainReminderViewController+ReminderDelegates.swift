//
//  MainReminderViewController+ReminderDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/26/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIReminderCellDelegate {
    
    func didTapReminderButton(_ cell: UIReminderCell, type: UIReminderButtonType) {
        guard let indexPath = tableView.indexPath(for: cell),
              case let .reminder(type) = type else {
            return
        }

        switch type {
        case .complete:
            let reminder = viewmodel.getReminder(forIndexPath: indexPath)
            reminder.completed = cell.isCompleted()
            viewmodel.saveReminders()

            if reminder.completed {
                if let alarm = reminder.alarmDate as Date?, alarm < Date() {
                    print("Date completed, dropping badge number")
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                } else {
                    print("Date not completed, not dropping badge number")
                }
            } else {
                if let alarm = reminder.alarmDate as Date?, alarm < Date() {
                    print("Date completed, increasing badge number")
                    UIApplication.shared.applicationIconBadgeNumber += 1
                } else {
                    print("Date not completed, not increasing badge number")
                }
            }

        case .delete:
            viewmodel.deleteReminder(atIndexPath: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

            let reminder = viewmodel.getReminder(forIndexPath: indexPath)
            if !reminder.completed, let alarm = reminder.alarmDate as Date?, alarm < Date() {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }

        default:
            break
        }
    }
}
