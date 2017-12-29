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
        if selectedReminder != nil {
            count += 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for Rows:", indexPath)

        var reminderIndex = indexPath

        if let selectedReminder = selectedReminder {
            // If the action cell is requested
            if indexPath.row == selectedReminder.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.actionCellIdentifier) as! UIActionCell
                cell.delegate = self

                let item = reminderViewModel.getReminderTableViewModelItem(forIndexPath: selectedReminder)
                cell.setup(detail: item.detail, priority: item.priority)

                return cell
            }

            // If any cell after the action cell is requested
            if indexPath.row > selectedReminder.row + 1 {
                reminderIndex.row = reminderIndex.row - 1
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reminderCellIdentifier, for: indexPath) as! UIReminderCell
        cell.setTitleDelegate(controller: self)
        cell.buttonDelegate = self

        let item = reminderViewModel.getReminderTableViewModelItem(forIndexPath: reminderIndex)
        var endSub = false
        if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
            endSub = true
        }

        cell.setup(item: item, filtering: filterMode, endSub: endSub)
        return cell
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentMode == .editReminder || currentMode == .editPriority {
            return Constants.estimatedSmallExpandedActionRowHeight
        }

        if currentMode == .editAlarm {
            return Constants.estimatedLargeExpandedActionRowHeight
        }

        return Constants.estimatedReminderRowHeight
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("Will Select")

        if let cell = tableView.cellForRow(at: indexPath) {
            print("size:", cell.bounds.height)
        }

        // If nothing is currently selected, proceed as normal
        guard let selectedReminder = selectedReminder else {
            return indexPath
        }

        // If selecting an index above the current, proceed as normal
        if selectedReminder > indexPath {
            return indexPath
        }

        if selectedReminder == indexPath {
            if currentMode == .editReminder {
                guard let cell = tableView.cellForRow(at: selectedReminder) as? UIReminderCell else {
                    return nil
                }
                print("Current:", currentMode)
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

        if tableView.indexPathForSelectedRow == nil {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        selectedReminder = indexPath

        addButton.image = #imageLiteral(resourceName: "AddSubreminderIcon")
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

        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
        selectedReminder = nil

        currentMode = .main
        view.endEditing(true)
        addButton.image = #imageLiteral(resourceName: "AddIcon")
        var actionCellIndexPath = indexPath
        actionCellIndexPath.row = actionCellIndexPath.row + 1

        tableView.beginUpdates()
        tableView.deleteRows(at: [actionCellIndexPath], with: .none)
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        let cell = UIReminderView()

        let item = reminderViewModel.getReminderTableViewModelItem(forIndexPath: IndexPath.init(row: 0, section: 0))
        cell.setup(item: item, filtering: false)

        containerView.addSubview(cell)
        NSLayoutConstraint.setupAndActivate(constraints: [
            cell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cell.topAnchor.constraint(equalTo: containerView.topAnchor),
            cell.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        return containerView
    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//
//        return nil
//    }
}
