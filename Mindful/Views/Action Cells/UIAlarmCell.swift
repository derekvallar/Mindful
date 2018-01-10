//
//  UIAlarmCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIAlarmCellDelegate: class {
    func alarmDateSelected(_ cell: UIAlarmCell)
}

class UIAlarmCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?
    weak var alarmDelegate: UIAlarmCellDelegate?

    private var alarmStackView = UIStackView()

    private var onOffStackView = UIStackView()
    private var alarmLabel = UILabel()
    private var offButton = UICellButton()
    private var onButton = UICellButton()

    private var dateTimeButton = UICellButton()
    private var alarmPicker = UIDatePicker()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("Initing action cell")

        // Setup Variables

        alarmStackView.axis = .vertical
        alarmStackView.distribution = .fill

        onOffStackView.axis = .horizontal
        onOffStackView.distribution = .fill
        onOffStackView.spacing = 20.0

        alarmLabel.text = "Alarm:"
        alarmLabel.textColor = .textColor
        alarmLabel.font = UIFont.systemFont(ofSize: .reminderTextSize)
        alarmLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        offButton.type = .action(type: .alarmOff)
        offButton.setTitle(String.alarmOffButtonTitle, for: .normal)
        offButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
        offButton.setTitleColor(UIColor.backgroundColor, for: .selected)
        offButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        onButton.type = .action(type: .alarmOn)
        onButton.setTitle(String.alarmOnButtonTitle, for: .normal)
        onButton .setTitleColor(UIColor.textSecondaryColor, for: .normal)
        onButton.setTitleColor(UIColor.backgroundColor, for: .selected)
        onButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        dateTimeButton.type = .action(type: .alarmButton)
        dateTimeButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
//        alarmDateTimeButton.font = UIFont.systemFont(ofSize: .textSize)
        dateTimeButton.contentHorizontalAlignment = .left
        dateTimeButton.addTarget(self, action: #selector(alarmDateTimeButtonTapped(button:)), for: .touchUpInside)

        alarmPicker.datePickerMode = .dateAndTime
        alarmPicker.addTarget(self, action: #selector(dateSelected(picker:)), for: .valueChanged)

        contentView.addSubview(alarmStackView)
        alarmStackView.addArrangedSubview(onOffStackView)
        alarmStackView.addArrangedSubview(dateTimeButton)
        alarmStackView.addArrangedSubview(alarmPicker)

        onOffStackView.addArrangedSubview(alarmLabel)
        onOffStackView.addArrangedSubview(offButton)
        onOffStackView.addArrangedSubview(onButton)

        NSLayoutConstraint.setupAndActivate(constraints: [
            alarmStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .cellXSpacing),
            alarmStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .cellXSpacingInverse),
            alarmStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .cellYSpacing),
            alarmStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .cellYSpacingInverse)
        ])
    }

    func setup(alarm: Date?) {
        if let alarm = alarm {
            print("Found alarm:", alarm)
            offButton.isSelected = false
            onButton.isSelected = true
            dateTimeButton.isHidden = false
            alarmPicker.date = alarm
        } else {
            print("Didn't find alarm")
            offButton.isSelected = true
            onButton.isSelected = false
            dateTimeButton.isHidden = true
            alarmPicker.date = Date()
        }

        dateTimeButton.setTitle(getDateText(), for: .normal)
        alarmPicker.isHidden = true
    }

    func alarmIsSet() -> Bool {
        return onButton.isSelected ? true : false
    }

    func getAlarmDate() -> Date {
        print("PickerDate:", alarmPicker.date)
        return alarmPicker.date
    }

    private func getDateText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter.string(from: alarmPicker.date)
    }

    @objc private func alarmDateTimeButtonTapped(button: UICellButton) {
        print("Tapped")
        alarmPicker.isHidden = !alarmPicker.isHidden
        delegate?.didTapActionButton(type: button.type)
    }

    @objc private func onOffButtonTapped(button: UICellButton) {
        if button.isSelected {
            return
        }

        if button === onButton {
            offButton.isSelected = false
            onButton.isSelected = true
            dateTimeButton.isHidden = false
        } else {
            offButton.isSelected = true
            onButton.isSelected = false
            dateTimeButton.isHidden = true
            alarmPicker.isHidden = true
        }
        delegate?.didTapActionButton(type: button.type)
    }

    @objc private func dateSelected(picker: UIPickerView) {
        dateTimeButton.setTitle(getDateText(), for: .normal)
        alarmDelegate?.alarmDateSelected(self)
    }
}
