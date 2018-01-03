//
//  MainReminderViewController+CategoryDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

extension MainReminderViewController: UICategoryCellDelegate {

    func didTapCategoryButton(type: UIReminderButtonType) {
        guard let selectedIndex = selectedCellIndex,
            case let .category(type) = type else {
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

        case .alarm:
            mindfulMode.action = .alarm
            break

        case .subreminders:
            tableView(tableView, didDeselectRowAt: selectedIndex)
            mindfulMode.reminder = .subreminders
            mindfulMode.action = .none
            returnIndex = selectedIndex

            navigationItem.setRightBarButtonItems([addButton], animated: true)
            reminderViewModel.initializeSubreminders(ofIndexPath: selectedIndex, completion: { (completed) in
                if completed {
                    print("subreminder reloading")
                    let indexSet: IndexSet = [0]
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections(indexSet, with: .automatic)
                    self.tableView.endUpdates()
                }
            })

        case .back:
            if mindfulMode.action == .edit {
                guard let selectedCell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                    return
                }
                selectedCell.setUserInteraction(false)
//                reminderViewModel.updateReminder(completed: nil, title: selectedCell.getTitleText(), detail: cell.getDetailText(), priority: nil, indexPath: selectedIndex)
            } else if mindfulMode.action == .alarm {
//                print("Date:", cell.getAlarmDate())
//                reminderViewModel.updateReminder(completed: nil, title: nil, detail: nil, priority: nil, indexPath: selectedIndex)
            }
            mindfulMode.action = .none

        default:
            break
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
