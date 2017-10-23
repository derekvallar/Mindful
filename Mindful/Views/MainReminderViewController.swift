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
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        // Setup the table view

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
}

// MARK: - UITableViewDataSource
extension MainReminderViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
//        cell.backgroundColor = UIColor.clear
//        cell.setup(withTitle: viewModel.getTitle(forIndex: indexPath.row),
//                    detail: viewModel.getDetail(forIndex: indexPath.row))

        return cell
    }
}

















