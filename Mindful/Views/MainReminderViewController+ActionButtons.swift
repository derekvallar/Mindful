//
//  MainReminderViewController+ActionButtons.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/20/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIActionCellDelegate {
    func didTapButton(cell: UIActionCell, type: UIReminderButtonType) {

        print("Switching to:", type)
        guard let selectedReminder = selectedReminder else {
            return
        }


        switch type {
        case .edit:
            let reminderCell = tableView.cellForRow(at: selectedReminder) as! UIReminderCell
            reminderCell.setUserInteraction(true)
            currentMode = .editReminder
            scrollActionCellToMiddle()

        case .priority:
            currentMode = .editPriority
            scrollActionCellToMiddle()

        case .lowPriority:
            print("low priority")
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.low, indexPath: selectedReminder)

        case .mediumPriority:
            print("Medium priority")
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.medium, indexPath: selectedReminder)

        case .highPriority:
            print("high priority")
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.high, indexPath: selectedReminder)

        case .alarm:
            currentMode = .editAlarm
            break

        case .alarmLabel:
            scrollActionCellToMiddle()

        case .manageSubreminders:
            currentMode = .managingSubreminders
            reminderViewModel.initializeSubreminders(ofIndexPath: selectedReminder, completion: { (completed) in

                if completed {
                    self.tableView.reloadData()
                }
            })

            break

        case .returnAction:
            if currentMode == .editReminder {
                guard let selectedCell = tableView.cellForRow(at: selectedReminder) as? UIReminderCell else {
                    return
                }

                selectedCell.setUserInteraction(false)
print("yaknow?")
                reminderViewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: selectedReminder)
            } else if currentMode == .editAlarm {
                print("Date:", cell.getAlarmDate())
                reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: selectedReminder)
            }
            currentMode = .main

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()

    }
}
