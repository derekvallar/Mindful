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

    var reminderViewModel: ReminderViewModel!

    var addButton: UIBarButtonItem!
    var completedButton: UIBarButtonItem!
    var detailButton: UIBarButtonItem!

    var filterMode: Bool!
    var currentMode: MindfulMode!

    var selectedReminder: IndexPath?

    struct Rearrange {
        static var cell: UITableViewCell?
        static var snapshotView: UIView?
        static var snapshotOffset: CGFloat?
        static var currentIndexPath: IndexPath?

        static func clear() {
            Rearrange.snapshotView?.removeFromSuperview()
            Rearrange.cell = nil
            Rearrange.snapshotView = nil
            Rearrange.snapshotOffset = nil
            Rearrange.currentIndexPath = nil
        }
    }

    init(viewModel: ReminderViewModel) {
        super.init(nibName: nil, bundle: nil)
        reminderViewModel = viewModel
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

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(rearrangeLongPress(gestureRecognizer:)))
        view.addGestureRecognizer(longPressGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.backgroundView = UIView(frame: view.bounds)
//        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }

    func getActionCellIndex() -> IndexPath? {
        guard var actionIndex = selectedReminder else {
            return nil
        }
        actionIndex.row = actionIndex.row + 1
        return actionIndex
    }

    @objc func detailButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
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
            tableView(tableView, didDeselectRowAt: indexPath)

            let subreminderViewModel = reminderViewModel.getSubreminderViewModelForIndexPath(indexPath)
            let subreminderViewController = SubreminderViewController(viewModel: subreminderViewModel, startWithNewReminder: true)
            navigationController?.pushViewController(subreminderViewController, animated: true)
        } else {
            let firstRow = IndexPath.init(row: 0, section: 0)

            reminderViewModel.addReminder()
            tableView.beginUpdates()
            tableView.insertRows(at: [firstRow], with: .top)
            tableView.endUpdates()

            tableView(tableView, didSelectRowAt: firstRow)
        }
    }

    @objc func completedButtonPressed() {
print("Complete Pressed")

        if let indexPath = tableView.indexPathForSelectedRow {
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
        
        reminderViewModel.initializeTableData(withCompleted: completed) { result in
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

    // TODO: Currently scrolltoRow doesn't work w/o a delay. Find a fix in future iOS updates.
    func scrollActionCellToMiddle() {
        let deadlineTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.tableView.scrollToRow(at: self.getActionCellIndex()!, at: .middle, animated: true)
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
        let textViewPoint = textView.convert(textView.center, to: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: textViewPoint),
              let cell = tableView.cellForRow(at: indexPath) as? UIReminderCell else {
            return
        }

        reminderViewModel.updateReminder(completed: nil, title: cell.getTitleText(), detail: nil, priority: nil, indexPath: indexPath)
    }
}


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView(tableView, didDeselectRowAt: indexPath)
            view.endEditing(true)
        }
    }
}
















