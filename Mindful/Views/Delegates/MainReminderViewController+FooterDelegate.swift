//
//  MainReminderViewController+FooterDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

extension MainReminderViewController: UIReminderFooterViewDelegate {
    func didTapFooterReturn() {
        if let selectedIndex = indices.getSelected() {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        let oldReminder = mode.oldReminder ?? .main

        mode.action = .none

        if oldReminder == .completed {
            mode.reminder = .completed
            navigationItem.title = .completedTitle
            navigationItem.setRightBarButtonItems([completedButton], animated: true)

            viewmodel.initializeTableData(withCompleted: true, completion: { (completed) in
                let indexSet: IndexSet = [0]
                self.tableView.beginUpdates()
                self.tableView.reloadSections(indexSet, with: .automatic)
                self.tableView.endUpdates()

                self.tableView(self.tableView, didSelectRowAt: self.indices.getReturn()!)
                self.indices.clearReturn()
            })
        } else {
            mode.reminder = .main
            navigationItem.title = .mainTitle
            navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)

            viewmodel.initializeTableData(withCompleted: false, completion: { (completed) in
                let indexSet: IndexSet = [0]
                self.tableView.beginUpdates()
                self.tableView.reloadSections(indexSet, with: .automatic)
                self.tableView.endUpdates()

                self.tableView(self.tableView, didSelectRowAt: self.indices.getReturn()!)
                self.indices.clearReturn()
            })
        }

        mode.oldReminder = nil
    }
}
