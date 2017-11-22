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

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Main viewDidLoad()")

        // Setup the nav bar

        navigationItem.title = Constants.appName

        let rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addReminders))
        navigationItem.rightBarButtonItem = rightButton

        let leftButton = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterReminders))
        navigationItem.leftBarButtonItem = leftButton

        let textAtr = [
            NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAtr

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()


        // Setup the table view

        tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // TODO: Reload data only on return from DetailedReminderController
        tableView.reloadData()

        tableView.backgroundView = UIView(frame: view.bounds)
        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }


    @objc func filterReminders() {
        isFiltering = !isFiltering
        view.endEditing(true)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        for cell in tableView.visibleCells {
            let reminderCell = cell as? ReminderCell
            reminderCell?.changeFilterMode(isFiltering)
        }

        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @objc func addReminders() {
        let firstRow = IndexPath.init(row: 0, section: 0)

        ReminderTableViewModel.standard.addBlankReminder()
        tableView.beginUpdates()
        tableView.insertRows(at: [firstRow], with: .top)
        tableView.endUpdates()

        tableView.selectRow(at: firstRow, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: firstRow)
    }


    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        let priority = ReminderTableViewModel.standard.getPriority(forIndexPath: indexPath)
        let priorityImage: UIImage?

        switch priority {
        case .none:
            priorityImage = UIImage(named: Constants.emptyIconString)!
        case .priority:
            priorityImage = UIImage(named: Constants.priorityIconString)!
        case .highPriority:
            priorityImage = UIImage(named: Constants.highPriorityIconString)!
        }

        cell.titleTextView.delegate = self
        cell.buttonDelegate = self

        cell.setup(withTitle: title, detail: detail, priority: priorityImage, filtering: isFiltering)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !isFiltering {
            cell.userSelected(true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !isFiltering {
            cell.userSelected(false)
        }
    }
}


// MARK: - UITextFieldDelegate

extension MainReminderViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let textViewPoint = textView.convert(textView.center, to: view)
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint) else {
            return
        }

        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        ReminderTableViewModel.standard.updateReminder(withTitle: cell.titleTextView.text!, detail: nil, priority: nil, indexPath: indexPath)
    }
}


// MARK: - CellButtonDelegate

extension MainReminderViewController: CellButtonDelegate {
    func didTapButton(_ cell: ReminderCell, button: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if button == Constants.completeDeleteButtonString {
            if isFiltering {
                ReminderTableViewModel.standard.deleteReminder(atIndexPath: indexPath)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        } else if button == Constants.detailRearrangeButtonString {
            if isFiltering {

            } else {
                let viewModel = ReminderTableViewModel.standard.detailedReminderViewModelForIndexPath(indexPath)
                let detailedViewController = DetailedReminderViewController(viewModel: viewModel)
                navigationController?.pushViewController(detailedViewController, animated: true)
            }
        }
    }
}


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)
            view.endEditing(true)
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
}
















