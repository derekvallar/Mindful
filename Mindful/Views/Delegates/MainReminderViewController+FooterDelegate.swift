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
        if let selectedIndex = selectedCellIndex {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        mindfulMode.reminder = .main
        mindfulMode.action = .none
        navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)

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
