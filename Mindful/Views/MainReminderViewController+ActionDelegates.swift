//
//  MainReminderViewController+ActionDelegates.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/20/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIActionCellDelegate {
    func didTapButton(cell: UIActionCell, type: UIReminderButtonType) {

        guard let selectedIndex = selectedIndex else {
            return
        }

        switch type {
        case .edit:
            let reminderCell = tableView.cellForRow(at: selectedIndex) as! UIReminderCell
            reminderCell.setUserInteraction(true)
            mindfulMode.action = .edit
            scrollActionCellToMiddle()

        case .priority:
            mindfulMode.action = .priority
            scrollActionCellToMiddle()

        case .lowPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.low, indexPath: selectedIndex)

        case .mediumPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.medium, indexPath: selectedIndex)

        case .highPriority:
            reminderViewModel.updateReminder(completed: nil, title: nil, detail: cell.getDetailText(), priority: Priority.high, indexPath: selectedIndex)

        case .alarm:
            mindfulMode.action = .alarm
            break

        case .alarmLabel:
            scrollActionCellToMiddle()

        case .manageSubreminders:
            mindfulMode.reminder = .subreminders
            mindfulMode.action = .none

            returnIndex = selectedIndex
            tableView(tableView, didDeselectRowAt: selectedIndex)
            reminderViewModel.initializeSubreminders(ofIndexPath: selectedIndex, completion: { (completed) in
                if completed {
                    print("subreminder reloading")
                    let indexSet: IndexSet = [0]
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(indexSet, with: .automatic)
                    self.tableView.endUpdates()
                }
            })

        case .returnAction:
            if mindfulMode.action == .edit {
                guard let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                    return
                }

                selectedCell.setUserInteraction(false)
                reminderViewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: selectedIndex)
            } else if mindfulMode.action == .alarm {
                print("Date:", cell.getAlarmDate())
                reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: selectedIndex)
            }
            mindfulMode.action = .none

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()

    }
}

extension MainReminderViewController: UIReminderFooterViewDelegate {
    func didTapReturn() {
        mindfulMode.reminder = .main
        mindfulMode.action = .none

        if let selectedIndex = selectedIndex {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        reminderViewModel.initializeTableData(withCompleted: false, completion: { (completed) in
            let indexSet: IndexSet = [0]
            self.tableView.beginUpdates()
            self.tableView.reloadSections(indexSet, with: .automatic)
            self.tableView.endUpdates()

            self.tableView(self.tableView, didSelectRowAt: self.returnIndex!)
            self.returnIndex = nil
        })
    }
}
