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

    var oldTitle: String!
    var oldDetail: String!
    var oldPriority: Priority!

    public init(viewModel: DetailedReminderViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        detailedReminderView = DetailedReminderView(frame: CGRect.zero)
        self.view.addSubview(detailedReminderView)

        self.navigationItem.hidesBackButton = true

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = doneButton


        // Setup constraints

        let viewMargins = self.view.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            detailedReminderView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor),
            detailedReminderView.trailingAnchor.constraint(equalTo: viewMargins.trailingAnchor),
            detailedReminderView.topAnchor.constraint(equalTo: viewMargins.topAnchor),
            detailedReminderView.bottomAnchor.constraint(equalTo: viewMargins.bottomAnchor, constant: -15.0)])

        initializeFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.gradient(Constants.backgroundColor, secondColor: Constants.gradientColor)
    }

    func updateCoreData() {

    }

    func initializeFields() {
        let title = viewModel.getTitle()
        let detail = viewModel.getDetail()
        let priority = viewModel.getPriority()

        self.detailedReminderView.setup(title: title, detail: detail, priority: priority)
    }

    @objc func doneEditing() {
        let title = detailedReminderView.titleField.text
        let detail = detailedReminderView.detailsField.text
        let priority = Priority(rawValue: Int16(detailedReminderView.prioritySegmentedControl.selectedSegmentIndex))

        self.viewModel.updateReminder(title: title!, detail: detail!, priority: priority!)
        self.navigationController?.popViewController(animated: true)
    }
}
