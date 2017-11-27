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

    var viewModel: ReminderTableViewModel!

    var filterMode: Bool!
    var currentMode: MindfulMode!
    var previousMode: MindfulMode!

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        viewModel = ReminderTableViewModel.standard
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        filterMode = false
        currentMode = MindfulMode.main
        previousMode = MindfulMode.main

        // Setup the nav bar

        navigationItem.title = Constants.appName

        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "AddIcon"), style: .done, target: self, action: #selector(addButtonPressed))
        let completedButton = UIBarButtonItem(image: #imageLiteral(resourceName: "CompletedIcon"), style: .done, target: self, action: #selector(completedButtonPressed))
        
        addButton.tintColor = UIColor.white
        completedButton.tintColor = UIColor.white

        navigationItem.rightBarButtonItems = [addButton, completedButton]
        
        let detailButton = UIBarButtonItem(image: #imageLiteral(resourceName: "DetailIcon"), style: .done, target: self, action: #selector(detailButtonPressed))
        detailButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = detailButton

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


    @objc func detailButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView(tableView, didDeselectRowAt: indexPath)
        }

        toggleFilterMode()
    }

    @objc func completedButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView(tableView, didDeselectRowAt: indexPath)
        }

        if filterMode {
            toggleFilterMode()
        }

        var completed = false
        if currentMode == .main {
            completed = true
            currentMode = .completed
        } else if currentMode == .completed {
            currentMode = .main
        }

        viewModel.initializeTableData(withCompleted: completed) { (result) in
            if result {
                self.tableView.reloadData()
            } else {
                print("Could not fetch reminders")
            }
        }
    }

    @objc func addButtonPressed() {
        let firstRow = IndexPath.init(row: 0, section: 0)

        viewModel.addBlankReminder()
        tableView.beginUpdates()
        tableView.insertRows(at: [firstRow], with: .top)
        tableView.endUpdates()

        tableView.selectRow(at: firstRow, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: firstRow)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func toggleFilterMode() {
        filterMode = !filterMode
        if filterMode {
            for cell in tableView.visibleCells {
                let reminderCell = cell as? ReminderCell
                reminderCell?.changeFilterMode(true)
            }
        } else {
            for cell in tableView.visibleCells {
                let reminderCell = cell as? ReminderCell
                reminderCell?.changeFilterMode(false)
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension MainReminderViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reminders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell

        let completed = viewModel.getCompleted(forIndexPath: indexPath)
        let title = viewModel.getTitle(forIndexPath: indexPath)
        let detail = viewModel.getDetail(forIndexPath: indexPath)
        let priority = viewModel.getPriority(forIndexPath: indexPath)
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

        cell.setup(completed, title: title, detail: detail, priority: priorityImage, filtering: filterMode)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !filterMode {
            cell.userSelected(true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !filterMode {
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

        viewModel.updateReminder(title: cell.titleTextView.text!, detail: nil, priority: nil, indexPath: indexPath)
    }
}


// MARK: - CellButtonDelegate

extension MainReminderViewController: CellButtonDelegate {
    func didTapButton(_ cell: ReminderCell, button: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        if button == Constants.completeDeleteButtonString {
            if filterMode {
                viewModel.deleteReminder(atIndexPath: indexPath)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            } else {
                print("Complete button pushed:", cell.isCompleted())
                if let completed = cell.isCompleted() {
                    viewModel.setCompleted(completed: completed, indexPath: indexPath)
                }
            }
        } else if button == Constants.detailRearrangeButtonString {
            if filterMode {

            } else {
                let detailedViewModel = viewModel.detailedReminderViewModelForIndexPath(indexPath)
                let detailedViewController = DetailedReminderViewController(viewModel: detailedViewModel)
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
















