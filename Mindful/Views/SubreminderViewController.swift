//
//  SubreminderViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class SubreminderViewController: UIViewController {

    var viewModel: SubreminderViewModel!
    var tableView: UITableView!

    var detailButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!

    var filterMode: Bool!
    var startWithNewReminder: Bool!

    public init(viewModel: SubreminderViewModel, startWithNewReminder newReminder: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel

        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self

        detailButton = UIBarButtonItem(image: #imageLiteral(resourceName: "DetailIcon"), style: .done, target: self, action: #selector(detailButtonPressed))
        addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "AddIcon"), style: .done, target: self, action: #selector(addButtonPressed))

        filterMode = false
        startWithNewReminder = newReminder
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewDidLoad")

        view.addSubview(tableView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        print("Back exists:", navigationItem.backBarButtonItem != nil)

        navigationItem.leftBarButtonItem = detailButton
        navigationItem.rightBarButtonItem = addButton

        detailButton.tintColor = UIColor.white
        addButton.tintColor = UIColor.white

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("viewDidAppear")

        // TODO: Reload data only on return from DetailedReminderController
        tableView.reloadData()
        tableView.backgroundView = UIView(frame: view.bounds)
        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)

        if startWithNewReminder {
            viewModel.addReminder()

            let firstRow = IndexPath.init(row: 0, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [firstRow], with: .top)
            tableView.endUpdates()

            tableView.selectRow(at: firstRow, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: firstRow)
        }
    }

    @objc func detailButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView(tableView, didDeselectRowAt: indexPath)
        }

        filterMode = !filterMode
        setFilterMode(filterMode)
    }

    @objc func addButtonPressed() {
        let firstRow = IndexPath.init(row: 0, section: 0)

        viewModel.addReminder()
        tableView.beginUpdates()
        tableView.insertRows(at: [firstRow], with: .top)
        tableView.endUpdates()

        tableView.selectRow(at: firstRow, animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: firstRow)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setFilterMode(_ filter: Bool) {
        if filter {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = addButton
        }
        for cell in tableView.visibleCells {
            let reminderCell = cell as? ReminderCell
            reminderCell?.changeFilterMode(filter)
        }
    }
}

extension SubreminderViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getReminderCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell

        let item = viewModel.getReminderTableViewModelItem(forIndexPath: indexPath)
        cell.titleTextView.delegate = self
        cell.buttonDelegate = self
        cell.setup(item: item, hasSubreminders: false, filtering: filterMode)

        return cell
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = ReminderCell(style: ., reuseIdentifier: <#T##String?#>)
//    }
}

extension SubreminderViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !filterMode {
            cell.userSelected(true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return
        }

        if !filterMode {
            cell.userSelected(false)
        }
    }
}

extension SubreminderViewController: UITextViewDelegate {

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

        viewModel.updateReminder(completed: nil, title: cell.titleTextView.text!, detail: nil, priority: nil, indexPath: indexPath)
    }
}


// MARK: - CellButtonDelegate

extension SubreminderViewController: CellButtonDelegate {
    func didTapButton(_ cell: ReminderCell, button: UICellButtonType) {
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

        case .rearrange:
            break

        case .subreminder:
            break

        case .none:
            break
        }
    }
}


// MARK: - Scrolling functions for new reminders

extension SubreminderViewController {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView(tableView, didDeselectRowAt: indexPath)
            view.endEditing(true)
        }
    }
}

