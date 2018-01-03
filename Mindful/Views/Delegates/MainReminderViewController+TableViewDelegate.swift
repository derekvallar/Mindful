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
        var count = reminderViewModel.getReminderCount()
        if selectedCellIndex != nil {
            count += 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for Rows:", indexPath)

        var reminderIndex = indexPath

        if let selectedCellIndex = selectedCellIndex {
            // If the action cell is requested
            if indexPath.row == selectedCellIndex.row + 1 {

                let actionCell = tableView.dequeueReusableCell(withIdentifier: .actionCellIdentifier) as! UICategoryCell
                actionCell.delegate = self
                let item = reminderViewModel.getReminderItem(forIndexPath: selectedCellIndex)
                actionCell.setup(isSubreminder: item.isSubreminder)

                return actionCell
            }

            // If any cell after the action cell is requested
            if indexPath.row > selectedCellIndex.row + 1 {
                reminderIndex.row = reminderIndex.row - 1
            }
        }

        let reminderCell = tableView.dequeueReusableCell(withIdentifier: .reminderCellIdentifier, for: indexPath) as! UIReminderCell
        reminderCell.setTitleDelegate(controller: self)
        reminderCell.buttonDelegate = self

        let item = reminderViewModel.getReminderItem(forIndexPath: reminderIndex)
        var lastSubreminder = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            lastSubreminder = true
        }

        reminderCell.setup(item: item, filtering: mindfulMode.filter, lastSubreminder: lastSubreminder)
        return reminderCell
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if mindfulMode.action == .edit || mindfulMode.action == .priority {
            return .estimatedSmallExpandedActionRowHeight
        }

        if mindfulMode.action == .alarm {
            return .estimatedLargeExpandedActionRowHeight
        }

        return .estimatedReminderRowHeight
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Will Select")

//        if let cell = tableView.cellForRow(at: indexPath) {
//            print("size:", cell.bounds.height)
//        }

        if mindfulMode.filter == true {
            return nil
        }

        // If nothing is currently selected, proceed as normal
        guard let selectedIndex = selectedCellIndex else {
            return indexPath
        }

        // If selecting an index above the current, proceed as normal
        if selectedIndex > indexPath {
            return indexPath
        }

        if selectedIndex == indexPath {
            if mindfulMode.action == .edit {
                guard let cell = tableView.cellForRow(at: selectedIndex) as? UIReminderCell else {
                    return nil
                }
                cell.titleViewBecomeFirstResponder()
                return nil
            }

            self.tableView(tableView, didDeselectRowAt: selectedIndex)
            return nil
        }

        // If selecting the action cell or same cell, do nothing
        if selectedIndex.row + 1 == indexPath.row {
            return nil
        }

        var intendedSelection = indexPath
        intendedSelection.row = intendedSelection.row - 1
        return intendedSelection
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select")

        if selectedCellIndex == nil {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

        selectedCellIndex = indexPath
        categoryCellIndex = indexPath
        categoryCellIndex!.row = categoryCellIndex!.row + 1

        tableView.beginUpdates()
        tableView.insertRows(at: [categoryCellIndex!], with: .automatic)
        tableView.endUpdates()

        let deadlineTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Did deselect:", indexPath)

        view.endEditing(true)
        if let selectedIndex = selectedCellIndex {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }

        var deleteRows = [categoryCellIndex!]
        if let actionCellIndex = actionCellIndex {
            deleteRows.append(actionCellIndex)
        }

        tableView.beginUpdates()
        tableView.deleteRows(at: deleteRows, with: .automatic)
        tableView.endUpdates()

        selectedCellIndex = nil
        categoryCellIndex = nil
        actionCellIndex = nil
        mindfulMode.action = .none
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("CheckingHeader")
        if mindfulMode.reminder != .subreminders {
            return nil
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .reminderHeaderViewIdentitfier) as! UIReminderHeaderView
        headerView.setup(item: reminderViewModel.getHeaderReminderItem())
        headerView.delegate = self

        return headerView
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("CheckingFooter")
        if mindfulMode.reminder != .subreminders {
            return nil
        }

        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .reminderFooterViewIdentitfier) as! UIReminderFooterView
        footerView.delegate = self

        return footerView
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if mindfulMode.reminder == .subreminders {
            return .estimatedReminderRowHeight
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if mindfulMode.reminder == .subreminders {
            return .footerRowHeight
        }
        return 0
    }
}