//
//  MainReminderViewController+ReminderButtons.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/26/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController: UIReminderCellDelegate {
    func didTapButton(_ cell: UIReminderCell, button: UIReminderButtonType) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        switch button {
        case .complete:
            if let completed = cell.isCompleted() {
                viewModel.updateReminder(completed: completed, title: nil, detail: nil, priority: nil, indexPath: indexPath)
            }

        case .delete:
            viewModel.deleteReminder(atIndexPath: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()

        case .detail:
            let detailedViewModel = viewModel.getDetailedReminderViewModelForIndexPath(indexPath)
            let detailedViewController = DetailedReminderViewController(viewModel: detailedViewModel)
            navigationController?.pushViewController(detailedViewController, animated: true)

            if let selectedIndex = tableView.indexPathForSelectedRow {
                tableView(tableView, didDeselectRowAt: selectedIndex)
            }

        case .rearrange:
            break

        case .subreminder:
            let subreminderViewModel = viewModel.getSubreminderViewModelForIndexPath(indexPath)
            let subreminderViewController = SubreminderViewController(viewModel: subreminderViewModel, startWithNewReminder: false)
            navigationController?.pushViewController(subreminderViewController, animated: true)

            if let selectedIndex = tableView.indexPathForSelectedRow {
                tableView(tableView, didDeselectRowAt: selectedIndex)
            }

        default:
            break
        }
    }
}
