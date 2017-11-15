//
//  CreateMomentViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/15/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class DetailedReminderViewController: UIViewController {

    var viewModel: DetailedReminderViewModel!

    var detailedReminderView: DetailedReminderView!
    var reminderIndex: IndexPath!

    var oldTitle: String!
    var oldDetail: String!
    var oldPriority: Priority!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = DetailedReminderViewModel()

        detailedReminderView = DetailedReminderView(frame: CGRect.zero)
        self.view.addSubview(detailedReminderView)

        // Setup constraints
        let viewMargins = self.view.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            detailedReminderView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            detailedReminderView.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor),
            detailedReminderView.topAnchor.constraint(equalTo: viewMargins.topAnchor),
            detailedReminderView.bottomAnchor.constraint(equalTo: viewMargins.bottomAnchor, constant: -15.0)])

        // Initialize views
        let title = ReminderTableViewModel.standard.getTitle(forIndexPath: reminderIndex)
        detailedReminderView.setup(title)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }

    func updateCoreData() {

    }

    func setup(_ reminder: Reminder) {

    }
}
