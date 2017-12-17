//
//  DetailedReminderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/8/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class DetailedReminderView: UIView {

    var titleTextView: UITextView!
    var detailsField: UITextField!
    var prioritySegmentedControl: UISegmentedControl!
    var alarmPicker: UIDatePicker!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(title: String, detail: String, priority: Priority) {
        titleTextView.text = title
        detailsField.text = detail
        prioritySegmentedControl.selectedSegmentIndex = Int(priority.rawValue)
    }

    private func setupLayout() {
        let scrollView: UIScrollView!
        let stackView: UIStackView!
        let mentionStackView: UIStackView!
        let remindLabel: UILabel!

        let noneSegment = "None"
        let prioritySegment = #imageLiteral(resourceName: "PriorityIcon")
        let highPrioritySegment = #imageLiteral(resourceName: "HighPriorityIcon")

        let indicatorButton: UIButton!

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10

        // Setting up the structure

        scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true

        self.addSubview(scrollView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.layoutSpacing),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.layoutSpacingInverse),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.layoutSpacing),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.layoutSpacingInverse)])

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20.0

        scrollView.addSubview(stackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)])

        titleTextView = UITextView()
        titleTextView.font = UIFont.systemFont(ofSize: 17.5)
        titleTextView.textColor = Constants.textColor
        titleTextView.isScrollEnabled = false
        
        titleTextView.textContainerInset = UIEdgeInsets.zero
        titleTextView.textContainer.lineFragmentPadding = 0.0
        titleTextView.layer.masksToBounds = false
        stackView.addArrangedSubview(titleTextView)

        detailsField = UITextField()
        detailsField.placeholder = "Add details"
        detailsField.font = UIFont.systemFont(ofSize: 15.5)
        detailsField.textColor = Constants.textWrittenSecondaryColor
        stackView.addArrangedSubview(detailsField)

        prioritySegmentedControl = UISegmentedControl(items: [noneSegment, prioritySegment, highPrioritySegment])
        prioritySegmentedControl.selectedSegmentIndex = 0
        stackView.addArrangedSubview(prioritySegmentedControl)

        let line = UISeparatorLine(withColor: Constants.textSecondaryColor, height: 1.0)
        stackView.addArrangedSubview(line)

        mentionStackView = UIStackView()
        mentionStackView.axis = .horizontal
        mentionStackView.alignment = .center
        mentionStackView.distribution = .fill
        stackView.addArrangedSubview(mentionStackView)

        remindLabel = UILabel()
        remindLabel.textColor = Constants.textColor
        remindLabel.text = "Mention on a date"
        mentionStackView.addArrangedSubview(remindLabel)

        indicatorButton = UIButton(type: .custom)
        indicatorButton.setBackgroundImage(#imageLiteral(resourceName: "CompleteIndicator"), for: .normal)
        indicatorButton.setBackgroundImage(#imageLiteral(resourceName: "CheckedCompleteIndicator"), for: .selected)
        indicatorButton.addTarget(self, action: #selector(mentionButtonPressed(sender:)), for: .touchUpInside)
        indicatorButton.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251.0), for: UILayoutConstraintAxis.horizontal)
        mentionStackView.addArrangedSubview(indicatorButton)


        // TODO: Figure out animation bug with alarm picker

        alarmPicker = UIDatePicker()
        alarmPicker.datePickerMode = .dateAndTime
        alarmPicker.isHidden = true
        alarmPicker.setContentCompressionResistancePriority(UILayoutPriority.init(251.0), for: UILayoutConstraintAxis.vertical)
        stackView.addArrangedSubview(alarmPicker)

//        let segmentLine = UISeparatorLine(withColor: Constants.textSecondaryColor, height: 1.0)
//        stackView.addArrangedSubview(segmentLine)
    }

    @objc func mentionButtonPressed(sender: UIButton!) {
        guard let button = sender else {
            return
        }

        button.isSelected = button.isSelected ? false : true
        UIView.animate(withDuration: 0.4, animations: {
            self.alarmPicker.isHidden = !button.isSelected
            self.alarmPicker.alpha = button.isSelected ? 100.0 : 0.0
        })
    }
}

