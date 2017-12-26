//
//  UIActionCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/18/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIActionCellDelegate: class {
    func didTapButton(cell: UIActionCell, type: UIReminderButtonType)
}

class UIActionCell: UITableViewCell {

    private var actionCellStackView = UIStackView()

    private var actionButtonStackView = UIStackView()
    private var editTextButton = UICellButton()
    private var changePriorityButton = UICellButton()
    private var setAlarmButton = UICellButton()
    private var addSubreminderButton = UICellButton()
    private var returnButton = UICellButton()

    private var editLabel = UILabel()
    private var editTextView = UITextView()

    private var priorityLabel = UILabel()
    private var priorityStackView = UIStackView()
    private var lowPriorityButton = UICellButton()
    private var mediumPriorityButton = UICellButton()
    private var highPriorityButton = UICellButton()

    private var alarmLabel = UILabel()
    private var alarmDateTimeLabel = UILabel()
    private var alarmPicker = UIDatePicker()

    weak var delegate: UIActionCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("Initing action cell")

        // Setup Variables

        actionCellStackView.axis = .vertical
        actionCellStackView.distribution = .fill
        actionCellStackView.alignment = .fill
        actionCellStackView.spacing = Constants.actionViewSpacing

        actionButtonStackView.axis = .horizontal
        actionButtonStackView.distribution = .fillEqually
        actionButtonStackView.alignment = .center

        editTextButton.type = .edit
        editTextButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        editTextButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        changePriorityButton.type = .priority
        changePriorityButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        changePriorityButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        setAlarmButton.type = .alarm
        setAlarmButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        setAlarmButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        addSubreminderButton.type = .addSubreminder
        addSubreminderButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        addSubreminderButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        returnButton.type = .returnAction
        returnButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        returnButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        editLabel.text = "Notes:"
        editLabel.textColor = Constants.textColor
        editLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        editTextView.isScrollEnabled = false
        editTextView.textColor = Constants.textColor
        editTextView.backgroundColor = Constants.backgroundTextFieldColor
        editTextView.font = UIFont.systemFont(ofSize: Constants.textSize)

        priorityLabel.text = "Priority:"
        priorityLabel.textColor = Constants.textColor
        priorityLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        priorityStackView.axis = .horizontal
        priorityStackView.distribution = .fillEqually
        priorityStackView.spacing = 5.0

        lowPriorityButton.type = .lowPriority
        lowPriorityButton.setTitle("Low", for: .normal)
        lowPriorityButton.setTitleColor(Constants.lowPriorityColor, for: .normal)
        lowPriorityButton.setTitleColor(UIColor.white, for: .selected)
        lowPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)

        lowPriorityButton.backgroundColor = Constants.lowPriorityColor
        lowPriorityButton.layer.cornerRadius = 15.0
        lowPriorityButton.layer.borderColor = Constants.lowPriorityColor.cgColor
        lowPriorityButton.layer.borderWidth = Constants.buttonBorderWidth
        lowPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        mediumPriorityButton.type = .mediumPriority
        mediumPriorityButton.setTitle("Medium", for: .normal)
        mediumPriorityButton.setTitleColor(Constants.mediumPriorityColor, for: .normal)
        mediumPriorityButton.setTitleColor(UIColor.white, for: .selected)
        mediumPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)

        mediumPriorityButton.backgroundColor = Constants.mediumPriorityColor
        mediumPriorityButton.layer.cornerRadius = 15.0
        mediumPriorityButton.layer.borderColor = Constants.mediumPriorityColor.cgColor
        mediumPriorityButton.layer.borderWidth = Constants.buttonBorderWidth
        mediumPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        highPriorityButton.type = .highPriority
        highPriorityButton.setTitle("High", for: .normal)
        highPriorityButton.setTitleColor(Constants.highPriorityColor, for: .normal)
        highPriorityButton.setTitleColor(UIColor.white, for: .selected)
        highPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)

        highPriorityButton.backgroundColor = Constants.highPriorityColor
        highPriorityButton.layer.cornerRadius = 15.0
        highPriorityButton.layer.borderColor = Constants.highPriorityColor.cgColor
        highPriorityButton.layer.borderWidth = Constants.buttonBorderWidth
        highPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        alarmLabel.text = "Alarm:"
        alarmLabel.textColor = Constants.textColor
        alarmLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        alarmDateTimeLabel.text = "Test Date at Test Time"
        alarmDateTimeLabel.textColor = Constants.textSecondaryColor
        alarmDateTimeLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        alarmPicker.datePickerMode = .dateAndTime

        setup(detail: nil, priority: Priority.low)

        // Setup Subviews

        contentView.addSubview(actionCellStackView)
        actionCellStackView.addArrangedSubview(editLabel)
        actionCellStackView.addArrangedSubview(editTextView)
        actionCellStackView.addArrangedSubview(priorityLabel)
        actionCellStackView.addArrangedSubview(priorityStackView)
        actionCellStackView.addArrangedSubview(alarmLabel)
        actionCellStackView.addArrangedSubview(alarmDateTimeLabel)
        actionCellStackView.addArrangedSubview(alarmPicker)
        actionCellStackView.addArrangedSubview(actionButtonStackView)

        priorityStackView.addArrangedSubview(lowPriorityButton)
        priorityStackView.addArrangedSubview(mediumPriorityButton)
        priorityStackView.addArrangedSubview(highPriorityButton)

        actionButtonStackView.addArrangedSubview(editTextButton)
        actionButtonStackView.addArrangedSubview(changePriorityButton)
        actionButtonStackView.addArrangedSubview(setAlarmButton)
        actionButtonStackView.addArrangedSubview(addSubreminderButton)
        actionButtonStackView.addArrangedSubview(returnButton)


        // Setup Constraints

        // Silences UIView-Encapsulated-Layout-Height constraint error
        let bottomConstraint = actionCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cellYSpacingInverse)
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.setupAndActivate(constraints: [
            actionCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellXSpacing),
            actionCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cellXSpacingInverse),
            actionCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellYSpacing),
            bottomConstraint
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func actionPressed(button: UICellButton) {
        self.changeModeViews(button.type)
        delegate?.didTapButton(cell: self, type: button.type)
    }

    func setup(detail: String?, priority: Priority?) {
        if let detail = detail {
            editTextView.text = detail
        } else {
            editTextView.text = ""
        }

        lowPriorityButton.isSelected = false
        mediumPriorityButton.isSelected = false
        highPriorityButton.isSelected = false

        if let priority = priority {
            if priority == Priority.high {
                selectPriority(highPriorityButton)
            } else if priority == Priority.medium {
                selectPriority(mediumPriorityButton)
            } else {
                selectPriority(lowPriorityButton)
            }
        }

        changeModeViews(.returnAction)
    }

    func getDetailText() -> String {
        return editTextView.text
    }

    func getAlarmDate() -> Date {
        return alarmPicker.date
    }

    @objc private func selectPriority(_ selected: UICellButton) {
        for view in priorityStackView.arrangedSubviews {
            guard let button = view as? UICellButton else {
                return
            }

            if button === selected {
                button.isSelected = true

                if button.type == .lowPriority {
                    button.backgroundColor = Constants.lowPriorityColor
                } else if button.type == .mediumPriority {
                    button.backgroundColor = Constants.mediumPriorityColor
                } else if button.type == .highPriority {
                    button.backgroundColor = Constants.highPriorityColor
                }
            } else {
                button.isSelected = false
                button.backgroundColor = UIColor.clear
            }
        }

//        button.isSelected = !button.isSelected
//        if button.isSelected {

//        } else {
//            button.backgroundColor = UIColor.clear
//        }
    }

    private func changeModeViews(_ type: UIReminderButtonType) {
        switch type {
        case .edit:
            editLabel.isHidden = false
            editTextView.isHidden = false

        case .priority:
            priorityLabel.isHidden = false
            priorityStackView.isHidden = false

        case .alarm:
            alarmLabel.isHidden = false
            alarmDateTimeLabel.isHidden = false
            alarmPicker.isHidden = false

        case .returnAction:
            returnButton.isHidden = true
            editLabel.isHidden = true
            editTextView.isHidden = true
            priorityLabel.isHidden = true
            priorityStackView.isHidden = true
            alarmLabel.isHidden = true
            alarmDateTimeLabel.isHidden = true
            alarmPicker.isHidden = true

            editTextButton.isHidden = false
            changePriorityButton.isHidden = false
            setAlarmButton.isHidden = false
            addSubreminderButton.isHidden = false

        default:
            break
        }

        if type != .returnAction {
            returnButton.isHidden = false
            editTextButton.isHidden = true
            changePriorityButton.isHidden = true
            setAlarmButton.isHidden = true
            addSubreminderButton.isHidden = true
        }
    }
}
