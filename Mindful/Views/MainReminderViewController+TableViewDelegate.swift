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
        if selectedIndex != nil {
            count += 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for Rows:", indexPath)

        var reminderIndex = indexPath

        if let selectedReminder = selectedIndex {
            // If the action cell is requested
            if indexPath.row == selectedReminder.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: .actionCellIdentifier) as! UIActionCell
                cell.delegate = self

                let item = reminderViewModel.getReminderItem(forIndexPath: selectedReminder)
                cell.setup(detail: item.detail, priority: item.priority)

                return cell
            }

            // If any cell after the action cell is requested
            if indexPath.row > selectedReminder.row + 1 {
                reminderIndex.row = reminderIndex.row - 1
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: .reminderCellIdentifier, for: indexPath) as! UIReminderCell
        cell.setTitleDelegate(controller: self)
        cell.buttonDelegate = self

        let item = reminderViewModel.getReminderItem(forIndexPath: reminderIndex)
        var endSub = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            endSub = true
        }

        cell.setup(item: item, filtering: mindfulMode.filter, endSub: endSub)
        return cell
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

        // If nothing is currently selected, proceed as normal
        guard let selectedReminder = selectedIndex else {
            return indexPath
        }

        // If selecting an index above the current, proceed as normal
        if selectedReminder > indexPath {
            return indexPath
        }

        if selectedReminder == indexPath {
            if mindfulMode.action == .edit {
                guard let cell = tableView.cellForRow(at: selectedReminder) as? UIReminderCell else {
                    return nil
                }
                cell.titleViewBecomeFirstResponder()
                return nil
            }

            self.tableView(tableView, didDeselectRowAt: selectedReminder)
            return nil
        }

        // If selecting the action cell or same cell, do nothing
        if selectedReminder.row + 1 == indexPath.row {
            return nil
        }

        var intendedSelection = indexPath
        intendedSelection.row = intendedSelection.row - 1
        return intendedSelection
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select")

        if selectedIndex == nil {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        selectedIndex = indexPath

        var actionCellIndexPath = indexPath
        actionCellIndexPath.row = actionCellIndexPath.row + 1

        tableView.beginUpdates()
        tableView.insertRows(at: [actionCellIndexPath], with: .automatic)
        tableView.endUpdates()

        let deadlineTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Did deselect:", indexPath)

        if let selectedReminder = selectedIndex {
            tableView.deselectRow(at: selectedReminder, animated: true)
        }
        selectedIndex = nil

        mindfulMode.action = .none
        view.endEditing(true)
        addButton.image = #imageLiteral(resourceName: "AddIcon")
        var actionCellIndexPath = indexPath
        actionCellIndexPath.row = actionCellIndexPath.row + 1

        tableView.beginUpdates()
        tableView.deleteRows(at: [actionCellIndexPath], with: .none)
        tableView.endUpdates()
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        print("CheckingHeader")
//        if mindfulMode.reminder != .subreminders {
//            return nil
//        }
//
//
//
//        return containerView
//    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("CheckingFooter")
        if mindfulMode.reminder != .subreminders {
            return nil
        }

        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .reminderFooterViewIdentitfier)
        return footerView
    }

    @objc private func returnButtonPressed() {
        mindfulMode.reminder = .main
        mindfulMode.action = .none

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
