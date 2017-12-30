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

    var addButton: UIBarButtonItem!, completedButton: UIBarButtonItem!, detailButton: UIBarButtonItem!

    // SelectedReminder exists because UITableview has uncontrollable deselects that causes crashes
    var selectedIndex: IndexPath?
    var returnIndex: IndexPath?

    var mindfulMode = MindfulMode()
    var rearrange: Rearrange?

    init(viewModel: ReminderViewModel) {
        super.init(nibName: nil, bundle: nil)
        reminderViewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the nav bar

        navigationItem.title = .mainTitle

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
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()


        // Setup the table view

        tableView.register(UIReminderCell.self, forCellReuseIdentifier: .reminderCellIdentifier)
        tableView.register(UIActionCell.self, forCellReuseIdentifier: .actionCellIdentifier)

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
        
//        tableView.backgroundView = UIView(frame: view.bounds)
//        tableView.backgroundView?.gradient(.backgroundColor, secondColor: .gradientColor)
    }

    func getActionCellIndex() -> IndexPath? {
        guard var actionIndex = selectedIndex else {
            return nil
        }
        actionIndex.row = actionIndex.row + 1
        return actionIndex
    }

    @objc func detailButtonPressed() {
        if let selectedReminder = selectedIndex {
            tableView(tableView, didDeselectRowAt: selectedReminder)
        }

        mindfulMode.filter = !mindfulMode.filter
        if mindfulMode.filter {
            navigationItem.title = .filterTitle
            navigationItem.rightBarButtonItems = nil
        } else {
            if mindfulMode.reminder == .main {
                navigationItem.title = .mainTitle
            } else if mindfulMode.reminder == .completed {
                navigationItem.title = .completedTitle
            }
            
            navigationItem.rightBarButtonItems = [addButton, completedButton]
        }
        
        for cell in tableView.visibleCells {
            let reminderCell = cell as? UIReminderCell
            reminderCell?.changeFilterMode(mindfulMode.filter)
        }
    }

    @objc func addButtonPressed() {
        if let selectedReminder = selectedIndex {
            tableView(tableView, didDeselectRowAt: selectedReminder)
        }
        reminderViewModel.addReminder()

        let firstRow = IndexPath.init(row: 0, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [firstRow], with: .top)
        tableView.endUpdates()

        tableView(tableView, didSelectRowAt: firstRow)
    }

    @objc func completedButtonPressed() {
print("Complete Pressed")

        if let selectedReminder = selectedIndex {
            tableView(tableView, didDeselectRowAt: selectedReminder)
        }

        var completed = false
        if mindfulMode.reminder == .main {
            completed = true
            navigationItem.rightBarButtonItems = [completedButton]
            navigationItem.title = .completedTitle
            mindfulMode.reminder = .completed
        } else if mindfulMode.reminder == .completed {
            navigationItem.rightBarButtonItems = [addButton, completedButton]
            navigationItem.title = .mainTitle
            mindfulMode.reminder = .main
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


// MARK: - Scrolling functions for new reminders

extension MainReminderViewController {

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let selectedReminder = selectedIndex {
            tableView(tableView, didDeselectRowAt: selectedReminder)
            view.endEditing(true)
        }
    }
}
















