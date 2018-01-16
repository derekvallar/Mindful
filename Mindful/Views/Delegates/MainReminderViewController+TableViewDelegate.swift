//
//  MainReminderViewController+TableViewDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/26/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = viewmodel.getReminderCount()
        count += indices.getExpandedCellCount()
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for Rows:", indexPath)

        var reminderIndex = indexPath

        if let selectedIndex = indices.getSelected(),
           indexPath > selectedIndex {

            if let categoryIndex = indices.getCategory(), categoryIndex == indexPath {

                let categoryCell = tableView.dequeueReusableCell(withIdentifier: .categoryCellIdentifier) as! UICategoryCell
                categoryCell.delegate = self
                let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)
                var show = true
                if mode.action != .none {
                    show = false
                }
                categoryCell.setup(isSubreminder: reminder.isSubreminder, showCategories: show)

                return categoryCell
            }

            if let actionIndex = indices.getAction(), actionIndex == indexPath {
                switch mode.action {
                case .edit:
                    let editCell = tableView.dequeueReusableCell(withIdentifier: .editCellIdentifier) as! UIEditCell
                    let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)

                    editCell.delegate = self
                    editCell.textDelegate = self
                    editCell.setup(detail: reminder.detail)
                    return editCell

                case .priority:
                    let priorityCell = tableView.dequeueReusableCell(withIdentifier: .priorityCellIdentifier) as! UIPriorityCell
                    let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)

                    priorityCell.delegate = self
                    priorityCell.setup(priority: Priority(rawValue: reminder.priority)!)
                    return priorityCell

                case .alarm:
                    let alarmCell = tableView.dequeueReusableCell(withIdentifier: .alarmCellIdentifier) as! UIAlarmCell
                    let reminder = viewmodel.getReminder(forIndexPath: selectedIndex)

                    alarmCell.delegate = self
                    alarmCell.alarmDelegate = self
                    alarmCell.setup(alarm: reminder.alarmDate as Date?)
                    return alarmCell

                default:
                    break
                }
            }

            // If any cell after the action cell is requested
            reminderIndex.row -= indices.getExpandedCellCount()
        }

        let reminderCell = tableView.dequeueReusableCell(withIdentifier: .reminderCellIdentifier, for: indexPath) as! UIReminderCell
        reminderCell.buttonDelegate = self
        reminderCell.textDelegate = self

        let reminder = viewmodel.getReminder(forIndexPath: reminderIndex)
        var lastSubreminder = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            lastSubreminder = true
        }

        reminderCell.setup(reminder: reminder, filtering: mode.filter, lastSubreminder: lastSubreminder)
        return reminderCell
    }


    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        print("Will Select:", indexPath)

        if mode.filter == true {
            return nil
        }

        // If nothing is currently selected, proceed as normal
        guard let selectedIndex = indices.getSelected(),
              let categoryIndex = indices.getCategory() else {
            return indexPath
        }

        // If selecting an index above the current, proceed as normal
        if indexPath < selectedIndex {
            return indexPath
        }

        if indexPath == selectedIndex {
            if mode.action == .edit {
                guard let cell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                    return nil
                }
                cell.titleViewBecomeFirstResponder()
                return nil
            }

            self.tableView(tableView, didDeselectRowAt: selectedIndex)
            return nil
        }

        if indexPath == categoryIndex {
            return nil
        }

        if let actionIndex = indices.getAction(), indexPath == actionIndex {
            return nil
        }

        var intendedSelection = indexPath
        intendedSelection.row -= indices.getExpandedCellCount()
        return intendedSelection
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Did Select:", indexPath)

        if indices.getSelected() == nil {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

        indices.setSelected(to: indexPath)
        guard let categoryIndex = indices.getCategory() else {
            return
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [categoryIndex], with: .automatic)
        tableView.endUpdates()

        scrollIndexToMiddleIfNeeded(categoryIndex)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("Did deselect:", indexPath)

        view.endEditing(true)
        if let selectedIndex = indices.getSelected() {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
        var deleteRows = [IndexPath]()
        deleteRows.append(indices.getCategory()!)
        if let actionIndex = indices.getAction() {
            deleteRows.append(actionIndex)
        }
        indices.clearSelected()
        mode.action = .none

        tableView.beginUpdates()
        tableView.deleteRows(at: deleteRows, with: .automatic)
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if mode.reminder != .subreminders {
            return nil
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .reminderHeaderViewIdentitfier) as! UIReminderHeaderView
        headerView.setup(reminder: viewmodel.getHeaderReminder())
        headerView.delegate = self

        return headerView
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if mode.reminder != .subreminders {
            return nil
        }

        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .reminderFooterViewIdentitfier) as! UIReminderFooterView
        footerView.delegate = self

        return footerView
    }


    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode.action == .edit || mode.action == .priority {
            return .estimatedSmallExpandedActionRowHeight
        }

        if mode.action == .alarm {
            return .estimatedLargeExpandedActionRowHeight
        }

        return .estimatedReminderRowHeight
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if mode.reminder == .subreminders {
            return .estimatedReminderRowHeight
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if mode.reminder == .subreminders {
            return .footerRowHeight
        }
        return 0
    }
}
