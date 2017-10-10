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

        let createReminderButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Pencil"), style: .done, target: self, action: #selector(createMoment))
        navigationItem.rightBarButtonItem = createReminderButton
        navigationItem.title = Constants.appName


        tableView.register(ReminderCell.self, forCellReuseIdentifier: "ReminderCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        
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

//        cell.setup(withTitle: viewModel.getTitle(forIndex: indexPath.row),
//                    detail: viewModel.getDetail(forIndex: indexPath.row))

        return cell
    }
}

















