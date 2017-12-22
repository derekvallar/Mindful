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

    var viewModel: ReminderViewModel!

    var addButton: UIBarButtonItem!
    var completedButton: UIBarButtonItem!
    var detailButton: UIBarButtonItem!

    var filterMode: Bool!
    var currentMode: MindfulMode!

    struct Rearrange {
        static var snapshotView: UIView?
        static var snapshotOffset: CGFloat?
        static var currentIndexPath: IndexPath?
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        viewModel = ReminderViewModel.standard
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

        // Setup the nav bar

        navigationItem.title = Constants.mainTitle

        addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "AddIcon"), style: .done, target: self, action: #selector(addButtonPressed))
        completedButton = UIBarButtonItem(image: #imageLiteral(resourceName: "CompletedIcon"), style: .done, target: self, action: #selector(completedButtonPressed))
        
        addButton.tintColor = UIColor.white
        completedButton.tintColor = UIColor.white

        navigationItem.rightBarButtonItems = [addButton, completedButton]

        detailButton = UIBarButtonItem(image: #imageLiteral(resourceName: "DetailIcon"), style: .done, target: self, action: #selector(detailButtonPressed))
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

        tableView.register(UIReminderCell.self, forCellReuseIdentifier: Constants.reminderCellIdentifier)
        tableView.register(UIActionCell.self, forCellReuseIdentifier: Constants.actionCellIdentifier)

        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(rearrangeLongPress(gestureRecognizer:)))
        tableView.addGestureRecognizer(longPressGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.backgroundView = UIView(frame: view.bounds)
//        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }

    @objc func detailButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)
        }

        filterMode = !filterMode
        if filterMode {
            navigationItem.title = Constants.filterTitle
            navigationItem.rightBarButtonItems = nil
        } else {
            if currentMode == .main {
                navigationItem.title = Constants.mainTitle
            } else if currentMode == .completed {
                navigationItem.title = Constants.completedTitle
            }
            
            navigationItem.rightBarButtonItems = [addButton, completedButton]
        }
        
        for cell in tableView.visibleCells {
            let reminderCell = cell as? UIReminderCell
            reminderCell?.changeFilterMode(filterMode)
        }
    }

    @objc func addButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)

            let subreminderViewModel = viewModel.getSubreminderViewModelForIndexPath(indexPath)
            let subreminderViewController = SubreminderViewController(viewModel: subreminderViewModel, startWithNewReminder: true)
            navigationController?.pushViewController(subreminderViewController, animated: true)
        } else {
            let firstRow = IndexPath.init(row: 0, section: 0)

            viewModel.addReminder()
            tableView.beginUpdates()
            tableView.insertRows(at: [firstRow], with: .top)
            tableView.endUpdates()

            tableView.selectRow(at: firstRow, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: firstRow)
        }
    }

    @objc func completedButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)
        }

        var completed = false
        if currentMode == .main {
            completed = true
            navigationItem.rightBarButtonItems = [completedButton]
            navigationItem.title = Constants.completedTitle
            currentMode = .completed
        } else if currentMode == .completed {
            navigationItem.rightBarButtonItems = [addButton, completedButton]
            navigationItem.title = Constants.mainTitle
            currentMode = .main
        }
        
        viewModel.initializeTableData(withCompleted: completed) { result in
            if result {
                self.tableView.reloadData()
            } else {
                print("Could not fetch reminders")
            }
        }
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
        var count = viewModel.getReminderCount()
        if tableView.indexPathForSelectedRow != nil {
            count += 1
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if indexPath.row == selectedIndexPath.row + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.actionCellIdentifier) as! UIActionCell
                cell.delegate = self

                let item = viewModel.getReminderTableViewModelItem(forIndexPath: selectedIndexPath)
                cell.setup(detail: item.detail, priority: item.priority)

                return cell
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reminderCellIdentifier, for: indexPath) as! UIReminderCell
        cell.titleTextView.delegate = self
        cell.buttonDelegate = self
        
        let item = viewModel.getReminderTableViewModelItem(forIndexPath: indexPath)
        let hasSubreminders = viewModel.hasSubreminders(indexPath: indexPath)
        cell.setup(item: item, hasSubreminders: hasSubreminders, filtering: filterMode)
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // If nothing is currently selected, proceed as normal
        guard let currentSelection = tableView.indexPathForSelectedRow else {
            return indexPath
        }

        // If selecting an index above the current, proceed as normal
        if currentSelection > indexPath {
            return indexPath
        }

        // If selecting the action cell or same cell, do nothing
        if currentSelection.row + 1 >= indexPath.row {
            return nil
        }

        var intendedSelection = indexPath
        intendedSelection.row = intendedSelection.row - 1
        return intendedSelection
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addButton.image = #imageLiteral(resourceName: "AddSubreminderIcon")
        var actionCellIndexPath = indexPath
        actionCellIndexPath.row = actionCellIndexPath.row + 1

        tableView.beginUpdates()
        tableView.insertRows(at: [actionCellIndexPath], with: .none)
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        addButton.image = #imageLiteral(resourceName: "AddIcon")
        var actionCellIndexPath = indexPath
        actionCellIndexPath.row = actionCellIndexPath.row + 1

        tableView.beginUpdates()
        tableView.deleteRows(at: [actionCellIndexPath], with: .none)
        tableView.endUpdates()
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
        let textViewPoint = textView.convert(textView.center, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint),
              let cell = tableView.cellForRow(at: indexPath) as? UIReminderCell else {
            return
        }

        viewModel.updateReminder(completed: nil, title: cell.titleTextView.text!, detail: nil, priority: nil, indexPath: indexPath)
    }
}


// MARK: - CellButtonDelegate

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


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)
            view.endEditing(true)
        }
    }
}
















