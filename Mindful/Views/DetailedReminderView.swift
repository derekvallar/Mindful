//
//  DetailedReminderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/8/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class DetailedReminderView: UIView {

    var titleField: UITextField!
    var alarmPicker: UIDatePicker!
    var prioritySegmentedControl: UISegmentedControl!
    var detailsField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

//    init(frame: CGRect)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 25
        self.layer.shadowOpacity = 0.25

        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true

        self.addSubview(scrollView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.layoutSpacing),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.layoutSpacing * -1),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.layoutSpacing),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.layoutSpacing * -1)])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5.0

        scrollView.addSubview(stackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])

        titleField = UITextField()
        titleField.placeholder = "Reminder"
        titleField.font = titleField.font?.withSize(25.0)
        stackView.addArrangedSubview(titleField)

        alarmPicker = UIDatePicker()
        alarmPicker.datePickerMode = .dateAndTime
        stackView.addArrangedSubview(alarmPicker)

        let noneSegment = "None"
        let prioritySegment = #imageLiteral(resourceName: "Priority")
        let highPrioritySegment = #imageLiteral(resourceName: "HighPriority")

        prioritySegmentedControl = UISegmentedControl(items: [noneSegment, prioritySegment, highPrioritySegment])
        prioritySegmentedControl.selectedSegmentIndex = 0

        stackView.addArrangedSubview(prioritySegmentedControl)

        detailsField = UITextField()
        detailsField.placeholder = "Add some details"
        self.addSubview(detailsField)
    }
}

