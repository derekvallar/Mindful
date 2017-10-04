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

        let createReminderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Pencil 75px"), style: .plain, target: self, action: #selector(createMoment))
        navigationItem.rightBarButtonItem = createReminderButton
        navigationItem.title = Constants.appName

        tableView.register(ReminderCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }


    @objc func createMoment() {

        let momentViewController = CreateReminderViewController()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}

















