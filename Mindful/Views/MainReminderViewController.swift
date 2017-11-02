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

    var test: UIView!
    var hideTest = false

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Main viewDidLoad()")


        // Setup the nav bar

        let createReminderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Pencil"), style: .done, target: self, action: #selector(createMoment))
        navigationItem.rightBarButtonItem = createReminderButton
        navigationItem.title = Constants.appName

        let textAtr = [
            NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAtr

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
//        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        // Setup the table view

        test = CreateReminderView(frame: CGRect(x: 0.0, y: -100.0, width: tableView.bounds.width, height: 100.0))

        tableView.addSubview(test)
        tableView.backgroundView = UIView(frame: self.view.bounds)
        tableView.backgroundView?.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)

        tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none


//        let refreshControl = UIRefreshControl()
////        refreshControl.tintColor = UIColor.clear
//        refreshControl.backgroundColor = UIColor.clear
//        let createReminderView = CreateReminderView(frame: refreshControl.bounds)
////        createReminderView.frame = refreshControl.bounds
//        refreshControl.addSubview(createReminderView)
//
//        tableView.addSubview(refreshControl)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("Main viewDidAppear()")

    }


    @objc func createMoment() {

        let momentViewController = DetailedReminderViewController()
        momentViewController.providesPresentationContextTransitionStyle = true
        momentViewController.definesPresentationContext = true
        momentViewController.modalPresentationStyle = .overCurrentContext
        momentViewController.modalTransitionStyle = .crossDissolve

        self.present(momentViewController, animated: true, completion: nil)
    }

    @objc func dismissKeyboard() {
        print("Tapped out")
//        if let _ = tableView.indexPathForSelectedRow {
//            print("Hooplah!")
//        }
//        self.view.endEditing(true)

    }
}

extension MainReminderViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Did being editing")

        guard let cell = findCell(fromTextField: textField) else {
            return
        }

        cell.oldTitle = cell.titleField.text
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did end editing")

        guard let cell = findCell(fromTextField: textField) else {
            return
        }

        if cell.titleField.text != cell.oldTitle {
            print("Must saved new text!")
        } else {
            print("naw it same")
        }
    }

    func findCell(fromTextField textField: UITextField) -> ReminderCell? {
        let textFieldPoint = textField.convert(textField.center, to: self.view)

        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPoint) else {
            return nil
        }

        guard let cell = self.tableView.cellForRow(at: indexPath) as? ReminderCell else {
            return nil
        }

        return cell
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
        cell.titleField.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected:", indexPath)

//        let cell = tableView.cellForRow(at: indexPath) as? ReminderCell
//        let titleField = cell?.titleField
//        titleField?.isUserInteractionEnabled = true
//        titleField?.becomeFirstResponder()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected:", indexPath)
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
        if hideTest && tableView.contentOffset.y >= 0.0 {
            test.isHidden = false
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

//        print("End scroll:", tableView.contentOffset)

        if tableView.contentOffset.y < -100.0 {
            var oldOffset = tableView.contentOffset
            tableView.contentInset = UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0.0, right: 0.0)
            tableView.contentOffset = oldOffset

            ReminderTableViewModel.standard.addReminder(withTitle: "Test")
            tableView.reloadData()
            test.isHidden = true

            print("offset1:", tableView.contentOffset)
            tableView.contentInset = UIEdgeInsets.zero
            print("offset2:", tableView.contentOffset)
            oldOffset.y += 100.0
            tableView.contentOffset = oldOffset
            print("offset3:", tableView.contentOffset)
            print("scroll offset3:", scrollView.contentOffset)
            hideTest = true

            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReminderCell
            cell?.titleField.becomeFirstResponder()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("ended decelerate")
    }

    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrolling animation done")
        if hideTest {
            print("will show hidden view")
            hideTest = false
        }
    }
}
















