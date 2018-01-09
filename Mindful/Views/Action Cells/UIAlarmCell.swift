//
//  UIAlarmCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

class UIAlarmCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?

    private var alarmStackView = UIStackView()

    private var onOffStackView = UIStackView()
    private var alarmLabel = UILabel()
    private var alarmOffButton = UICellButton()
    private var alarmOnButton = UICellButton()

    private var alarmDateTimeButton = UICellButton()
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

        alarmOffButton.type = .action(type: .alarmOff)
        alarmOffButton.setTitle(String.alarmOffButtonTitle, for: .normal)
        alarmOffButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
        alarmOffButton.setTitleColor(UIColor.backgroundColor, for: .selected)
        alarmOffButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        alarmOnButton.type = .action(type: .alarmOn)
        alarmOnButton.setTitle(String.alarmOnButtonTitle, for: .normal)
        alarmOnButton .setTitleColor(UIColor.textSecondaryColor, for: .normal)
        alarmOnButton.setTitleColor(UIColor.backgroundColor, for: .selected)
        alarmOnButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        alarmDateTimeButton.type = .action(type: .alarmButton)
        alarmDateTimeButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
//        alarmDateTimeButton.font = UIFont.systemFont(ofSize: .textSize)
        alarmDateTimeButton.contentHorizontalAlignment = .left
        alarmDateTimeButton.addTarget(self, action: #selector(alarmDateTimeButtonTapped(button:)), for: .touchUpInside)

        alarmPicker.datePickerMode = .dateAndTime
        alarmPicker.addTarget(self, action: #selector(dateSelected(picker:)), for: .valueChanged)

        contentView.addSubview(alarmStackView)
        alarmStackView.addArrangedSubview(onOffStackView)
        alarmStackView.addArrangedSubview(alarmDateTimeButton)
        alarmStackView.addArrangedSubview(alarmPicker)

        onOffStackView.addArrangedSubview(alarmLabel)
        onOffStackView.addArrangedSubview(alarmOffButton)
        onOffStackView.addArrangedSubview(alarmOnButton)

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
            alarmOffButton.isSelected = false
            alarmOnButton.isSelected = true
            alarmDateTimeButton.isHidden = false

            alarmPicker.date = alarm
        } else {
            print("Didn't find alarm")
            alarmOffButton.isSelected = true
            alarmOnButton.isSelected = false
            alarmDateTimeButton.isHidden = true
        }

        alarmDateTimeButton.setTitle(getDateText(), for: .normal)
        alarmPicker.isHidden = true
    }

    func getAlarmDate() -> Date {
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

        if button === alarmOnButton {
            alarmOffButton.isSelected = false
            alarmOnButton.isSelected = true
            alarmDateTimeButton.isHidden = false
        } else {
            alarmOffButton.isSelected = true
            alarmOnButton.isSelected = false
            alarmDateTimeButton.isHidden = true
            alarmPicker.isHidden = true
        }
        delegate?.didTapActionButton(type: button.type)
    }

    @objc private func dateSelected(picker: UIPickerView) {
        alarmDateTimeButton.setTitle(getDateText(), for: .normal)
        delegate?.didTapActionButton(type: .action(type: .alarmOn))
    }
}
