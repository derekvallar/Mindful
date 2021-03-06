//
//  ViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

class MainReminderViewController: UITableViewController {

    var viewmodel: ReminderViewModel!
    var mode = MindfulMode()
    var indices = ActionIndices()
    var rearrange: Rearrange?

    var addButton: UIBarButtonItem!, completedButton: UIBarButtonItem!, detailButton: UIBarButtonItem!

    init(viewModel: ReminderViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewmodel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the nav bar

        navigationItem.title = .mainTitle

        addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "AddIcon"), style: .done, target: self, action: #selector(addButtonPressed))
        addButton.tintColor = UIColor.white

        completedButton = UIBarButtonItem(image: #imageLiteral(resourceName: "CompletedIcon"), style: .done, target: self, action: #selector(completedButtonPressed))
        completedButton.tintColor = UIColor.white

        navigationItem.rightBarButtonItems = [addButton, completedButton]

        detailButton = UIBarButtonItem(image: #imageLiteral(resourceName: "DetailIcon"), style: .done, target: self, action: #selector(detailButtonPressed))
        detailButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = detailButton

        let textAtr = [
            NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAtr

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .backgroundBlue
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        // Setup the table view

        tableView.register(UIReminderCell.self, forCellReuseIdentifier: .reminderCellIdentifier)
        tableView.register(UICategoryCell.self, forCellReuseIdentifier: .categoryCellIdentifier)
        tableView.register(UIEditCell.self, forCellReuseIdentifier: .editCellIdentifier)
        tableView.register(UIPriorityCell.self, forCellReuseIdentifier: .priorityCellIdentifier)
        tableView.register(UIAlarmCell.self, forCellReuseIdentifier: .alarmCellIdentifier)

        tableView.register(UIReminderHeaderView.self, forHeaderFooterViewReuseIdentifier: .reminderHeaderViewIdentitfier)
        tableView.register(UIReminderFooterView.self, forHeaderFooterViewReuseIdentifier: .reminderFooterViewIdentitfier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = UITableViewAutomaticDimension

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
    }

    @objc func detailButtonPressed() {
        if let selectedIndex = indices.getSelected() {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        mode.filter = !mode.filter
        if mode.filter {
            navigationItem.title = .filterTitle
            navigationItem.setRightBarButtonItems(nil, animated: true)

            // TODO: Remove debug

            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { (requests) in
                print("Pending requests:", requests.count)
                for request in requests {
                    print((request.trigger as? UNCalendarNotificationTrigger)?.dateComponents)
                }
            }

            center.getDeliveredNotifications { (requests) in
                print("Delivered requests:", requests.count)
                for request in requests {
                    print((request.request.trigger as? UNCalendarNotificationTrigger)?.dateComponents)
                }
            }


        } else {
            if mode.reminder == .main {
                navigationItem.title = .mainTitle
                navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)
            } else if mode.reminder == .completed {
                navigationItem.title = .completedTitle
                navigationItem.setRightBarButtonItems([completedButton], animated: true)
            } else if mode.reminder == .subreminders {
                navigationItem.title = .subreminderTitle
                navigationItem.setRightBarButtonItems([addButton], animated: true)
            }
        }
        
        for cell in tableView.visibleCells {
            let reminderCell = cell as? UIReminderCell
            reminderCell?.changeFilterMode(mode.filter)
        }
    }

    @objc func addButtonPressed() {
        if let selectedIndex = indices.getSelected() {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        print("here")
        mode.creatingReminder = true
        viewmodel.addReminder()

        let firstRow = IndexPath.init(row: 0, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [firstRow], with: .top)
        tableView.endUpdates()

        print("huh")
        tableView(tableView, didSelectRowAt: firstRow)
        guard let cell = tableView.cellForRow(at: firstRow) as? UIReminderCell else {
            return
        }

        cell.titleViewBecomeFirstResponder()

        if mode.reminder == .main {
            navigationItem.setRightBarButtonItems([completedButton], animated: true)
        } else if mode.reminder == .subreminders {
            navigationItem.setRightBarButtonItems([completedButton], animated: true)
        }
    }

    @objc func completedButtonPressed() {
print("Complete Pressed")

        if let selectedIndex = indices.getSelected() {
            tableView(tableView, didDeselectRowAt: selectedIndex)
        }

        var completed = false
        if mode.reminder == .main {
            completed = true
            navigationItem.setRightBarButtonItems([completedButton], animated: true)
            navigationItem.title = .completedTitle
            navigationController?.navigationBar.barTintColor = .completedGreen
            mode.reminder = .completed

        } else if mode.reminder == .completed {
            navigationItem.setRightBarButtonItems([addButton, completedButton], animated: true)
            navigationItem.title = .mainTitle
            navigationController?.navigationBar.barTintColor = .backgroundBlue
            mode.reminder = .main
        }
        
        viewmodel.initializeTableData(withCompleted: completed) { result in
            if result {
                let indexSet: IndexSet = [0]
                self.tableView.beginUpdates()
                self.tableView.reloadSections(indexSet, with: .automatic)
                self.tableView.endUpdates()
            } else {
                print("Could not fetch reminders")
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // TODO: Currently scrolltoRow doesn't work w/o a delay. Find a fix in future iOS updates.
    func scrollIndexToMiddleIfNeeded(_ index: IndexPath?) {
        print("Trying to scroll")

        guard let index = index,
              let category = indices.getCategory() else {
            return
        }

        let rect = tableView.rectForRow(at: index)

        print("Scrolling to middle")
        let deadlineTime = DispatchTime.now() + .milliseconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.tableView.scrollRectToVisible(rect, animated: true)
        }
    }
}


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let selectedIndex = indices.getSelected() {
            tableView(tableView, didDeselectRowAt: selectedIndex)
            view.endEditing(true)
        }
    }
}
















