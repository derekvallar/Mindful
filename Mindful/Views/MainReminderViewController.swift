//
//  ViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import MapKit

class MainReminderViewController: UITableViewController {

    var isCreatingReminder = false
    var isFiltering = false
    var justFinishedTyping = false
    var remindersToDelete = [IndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Main viewDidLoad()")

        // Setup the nav bar

        let createReminderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Pencil"), style: .done, target: self, action: #selector(rightButton))
        navigationItem.rightBarButtonItem = createReminderButton
        navigationItem.title = Constants.appName

        let testButton = UIBarButtonItem(image: #imageLiteral(resourceName: "PriorityIcon"), style: .done, target: self, action: #selector(leftButton))
        navigationItem.leftBarButtonItem = testButton

        let textAtr = [
            NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAtr

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()


        // Setup the table view

        tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.rowHeight = Constants.cellHeight
        tableView.separatorStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
        tableView.backgroundView = UIView(frame: self.view.bounds)
        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }


    @objc func rightButton() {

        isFiltering = !isFiltering
        if !isFiltering {
            remindersToDelete.removeAll()
            for cell in tableView.visibleCells {
                let reminderCell = cell as? ReminderCell
                reminderCell?.setDeletionIndicator(to: false)
            }
        }

        for cell in tableView.visibleCells {
            let reminderCell = cell as? ReminderCell
            reminderCell?.showDeletionIndicator(isFiltering)
        }
    }

    @objc func leftButton() {

        if isFiltering {
            isFiltering = false
            ReminderTableViewModel.standard.deleteReminders(atIndices: remindersToDelete)
            tableView.reloadData()
            for cell in tableView.visibleCells {
                let reminderCell = cell as? ReminderCell
                reminderCell?.setDeletionIndicator(to: false)
                reminderCell?.showDeletionIndicator(false)
            }
            self.remindersToDelete.removeAll()

        } else {
            ReminderTableViewModel.standard.addBlankReminder()
            tableView.reloadData()
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReminderCell
            cell?.titleField.becomeFirstResponder()
        }
    }


    @objc func dismissKeyboard() {
        if self.justFinishedTyping {
            self.justFinishedTyping = false
        }
        self.view.endEditing(true)
    }
}


// MARK: - UITableViewDataSource

extension MainReminderViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderTableViewModel.standard.reminders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell

        let title = ReminderTableViewModel.standard.getTitle(forIndexPath: indexPath)
        let detail = ReminderTableViewModel.standard.getDetail(forIndexPath: indexPath)
        cell.titleField.delegate = self
        cell.indicatorDelegate = self

        cell.setup(withTitle: title, detail: detail, filterMode: isFiltering)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.justFinishedTyping == false {

            let viewModel = ReminderTableViewModel.standard.detailedReminderViewModelForIndexPath(indexPath)
            let detailedViewController = DetailedReminderViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(detailedViewController, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //        print("Deselected:", indexPath)
    }
}


// MARK: - UITextFieldDelegate

extension MainReminderViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldPoint = textField.convert(textField.center, to: self.view)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPoint) else {
            return
        }

        guard let cell = self.tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        cell.oldTitle = cell.titleField.text
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.justFinishedTyping = true

        let textFieldPoint = textField.convert(textField.center, to: self.view)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPoint) else {
            return
        }

        guard let cell = self.tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

//        if indexPath.row == 0 {
//            isCreatingReminder = false
//
//            if cell.titleField.text != cell.oldTitle {
//                print("Updated title, new")
//                ReminderTableViewModel.standard.updateReminder(withTitle: cell.titleField.text!, indexPath: indexPath)
//                ReminderTableViewModel.standard.addBlankReminder()
//
//                tableView.beginUpdates()
//                tableView.insertRows(at: [indexPath], with: .fade)
//                tableView.endUpdates()
//            }
//print("Gonna hide the blank")

        if cell.titleField.text != cell.oldTitle {
            ReminderTableViewModel.standard.updateReminder(withTitle: cell.titleField.text!, detail: nil, priority: nil, indexPath: indexPath)
        }

        cell.oldTitle = nil
    }
}


// MARK: - DeleteIndicatorDelegate

extension MainReminderViewController: DeleteIndicatorDelegate {
    func didTapIndicator(_ cell: ReminderCell, selected: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if selected {
            remindersToDelete.append(indexPath)
        } else if let index = remindersToDelete.index(of: indexPath) {
            remindersToDelete.remove(at: index)
        }
    }
}


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let pullDistance = max(0.0, -scrollView.contentOffset.y)
//
//        var frame = test.frame
//        if (pullDistance > frame.size.height) {
//            frame.origin.y = -pullDistance;
//        }
//        test.frame = frame;

//        if (self.refreshing) {
//            if (pullDistance == 0) {
//                self.tableView.contentInset = UIEdgeInsetsZero;
//            }
//        }

//        print("Scroll:", tableView.contentOffset.y, "HUH:", scrollView.contentOffset)

    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("end drag:", tableView.contentOffset)
//        print("Insets:", tableView.contentInset)

//        if isCreatingReminder == false && tableView.contentOffset.y < 0.0 {
////print("Bringing it all into view")
//
//            var oldOffset = tableView.contentOffset
//            tableView.contentInset = UIEdgeInsets.zero
//            tableView.contentOffset = oldOffset
//
//            isCreatingReminder = true
//
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReminderCell
//            cell?.titleField.becomeFirstResponder()
//        }
    }
}
















