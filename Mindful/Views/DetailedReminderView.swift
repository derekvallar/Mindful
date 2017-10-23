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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        let remindLabel: UILabel!
        let scrollView: UIScrollView!
        let stackView: UIStackView!
        let mentionStackView: UIStackView!

        let noneSegment = "None"
        let prioritySegment = #imageLiteral(resourceName: "Priority")
        let highPrioritySegment = #imageLiteral(resourceName: "HighPriority")

        let indicatorButton: UIButton!

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 25
        self.layer.shadowOpacity = 0.25


        // Setting up the structure

        scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true

        self.addSubview(scrollView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.layoutSpacing),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.layoutSpacing * -1),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.layoutSpacing),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.layoutSpacing * -1)])

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10.0

        scrollView.addSubview(stackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])


        // Setting up the UIViews

        titleField = UITextField()
        titleField.placeholder = "Reminder"
        titleField.textColor = Constants.textColor
        titleField.font = titleField.font?.withSize(25.0)
        stackView.addArrangedSubview(titleField)

        let line = UISeparatorLine(withColor: Constants.textSecondaryColor, height: 1.0)
        stackView.addArrangedSubview(line)

        mentionStackView = UIStackView()
        mentionStackView.axis = .horizontal
        mentionStackView.alignment = .center
        mentionStackView.distribution = .fill

        remindLabel = UILabel()
        remindLabel.textColor = Constants.textColor
        remindLabel.text = "Mention on a date"
        mentionStackView.addArrangedSubview(remindLabel)

        indicatorButton = UIButton(type: .custom)
        indicatorButton.setBackgroundImage(#imageLiteral(resourceName: "Indicator"), for: .normal)
        indicatorButton.setBackgroundImage(#imageLiteral(resourceName: "Checked Indicator"), for: .selected)
        indicatorButton.addTarget(self, action: #selector(mentionButtonPressed(sender:)), for: .touchUpInside)
        indicatorButton.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251.0), for: UILayoutConstraintAxis.horizontal)
        mentionStackView.addArrangedSubview(indicatorButton)

        stackView.addArrangedSubview(mentionStackView)

        alarmPicker = UIDatePicker()
        alarmPicker.datePickerMode = .dateAndTime
        stackView.addArrangedSubview(alarmPicker)

        let segmentLine = UISeparatorLine(withColor: Constants.textSecondaryColor, height: 1.0)
        stackView.addArrangedSubview(segmentLine)

        prioritySegmentedControl = UISegmentedControl(items: [noneSegment, prioritySegment, highPrioritySegment])
        prioritySegmentedControl.selectedSegmentIndex = 0

        stackView.addArrangedSubview(prioritySegmentedControl)

        detailsField = UITextField()
        detailsField.placeholder = "Add some details"
        self.addSubview(detailsField)
    }

    @objc func mentionButtonPressed(sender: UIButton!) {
        guard let button = sender else {
            return
        }

        button.isSelected = button.isSelected ? false : true
    }
}

