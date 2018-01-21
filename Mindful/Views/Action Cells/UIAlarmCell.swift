//
//  UIAlarmCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIAlarmCellDelegate: class {
    func alarmDateSelected()
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

        // Setup Variables

        selectionStyle = .none
        backgroundColor = UIColor.white
        clipsToBounds = true
        
        alarmStackView.axis = .vertical
        alarmStackView.distribution = .fill

        onOffStackView.axis = .horizontal
        onOffStackView.distribution = .fill
        onOffStackView.spacing = 20.0

        alarmLabel.text = "Alarm:"
        alarmLabel.textColor = .textColor
        alarmLabel.font = UIFont.systemFont(ofSize: .reminderTextSize)
        alarmLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        offButton.type = .action(type: .alarmOff)
        offButton.setTitle(String.alarmOffButtonTitle, for: .normal)
        offButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
        offButton.setTitleColor(UIColor.backgroundBlue, for: .selected)
        offButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        onButton.type = .action(type: .alarmOn)
        onButton.setTitle(String.alarmOnButtonTitle, for: .normal)
        onButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
        onButton.setTitleColor(UIColor.backgroundBlue, for: .selected)
        onButton.addTarget(self, action: #selector(onOffButtonTapped(button:)), for: .touchUpInside)

        dateTimeButton.type = .action(type: .alarmButton)
        dateTimeButton.setTitleColor(UIColor.textSecondaryColor, for: .normal)
//        alarmDateTimeButton.font = UIFont.systemFont(ofSize: .textSize)
        dateTimeButton.contentHorizontalAlignment = .left
        dateTimeButton.contentVerticalAlignment = .top
        dateTimeButton.setContentHuggingPriority(.defaultHigh, for: .vertical)

        dateTimeButton.addTarget(self, action: #selector(alarmDateTimeButtonTapped(button:)), for: .touchUpInside)

        alarmPicker.datePickerMode = .dateAndTime
        alarmPicker.addTarget(self, action: #selector(dateSelected(picker:)), for: .valueChanged)
        alarmPicker.setContentHuggingPriority(.defaultLow, for: .vertical)


        contentView.addSubview(alarmStackView)
        alarmStackView.addArrangedSubview(onOffStackView)
        alarmStackView.addArrangedSubview(dateTimeButton)
        alarmStackView.addArrangedSubview(alarmPicker)

        onOffStackView.addArrangedSubview(alarmLabel)
        onOffStackView.addArrangedSubview(offButton)
        onOffStackView.addArrangedSubview(onButton)

        NSLayoutConstraint.setupAndActivate(constraints: [
            alarmStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .actionCellLeading),
            alarmStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .actionCellTrailing),
            alarmStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .actionCellTop),
            alarmStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .actionCellBottom)
        ])
    }

    func setup(alarm: Date?) {
        if let alarm = alarm {
            offButton.isSelected = false
            onButton.isSelected = true
            dateTimeButton.isHidden = false
            alarmPicker.date = alarm
        } else {
            offButton.isSelected = true
            onButton.isSelected = false
            dateTimeButton.isHidden = true
            alarmPicker.date = Date()
        }

        dateTimeButton.setTitle(alarmPicker.date.getText(), for: .normal)
        alarmPicker.isHidden = true
    }

    func alarmIsSet() -> Bool {
        return onButton.isSelected ? true : false
    }

    func getAlarmDate() -> Date {
        return alarmPicker.date
    }

    func animatePicker(tableView: UITableView) {
        if alarmPicker.isHidden {
            print("Showing picker")

            UIView.animate(withDuration: .animateNormal) {
                self.alarmPicker.isHidden = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
            print("Hiding picker")

//            alarmPicker.isHidden = true
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            alarmPicker.isHidden = false

            UIView.animate(withDuration: .animateSubtle, animations: {
//                self.alarmPicker.frame.origin.y -= self.alarmPicker.frame.height
//                self.alarmPicker.alpha = 0.0
                self.alarmPicker.isHidden = true

            }, completion: { (_) in
//                self.alarmPicker.alpha = 1.0
//                self.alarmPicker.frame.origin.y += self.alarmPicker.frame.height
//                self.alarmPicker.isHidden = true
            })
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    @objc private func alarmDateTimeButtonTapped(button: UICellButton) {
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
        dateTimeButton.setTitle(alarmPicker.date.getText(), for: .normal)
        alarmDelegate?.alarmDateSelected()
    }
}

