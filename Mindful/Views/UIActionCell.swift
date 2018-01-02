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

    weak var delegate: UIActionCellDelegate?

    private var actionCellStackView = UIStackView()

    private var actionButtonStackView = UIStackView()
    private var editTextButton = UICellButton()
    private var changePriorityButton = UICellButton()
    private var setAlarmButton = UICellButton()
    private var subreminderButton = UICellButton()
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
    private var alarmIsExpanded = false

    private var isSubreminder = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("Initing action cell")

        // Setup Variables

        actionCellStackView.axis = .vertical
        actionCellStackView.distribution = .fill
        actionCellStackView.alignment = .fill
        actionCellStackView.spacing = .actionViewSpacing

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

        subreminderButton.type = .manageSubreminders
        subreminderButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        subreminderButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        returnButton.type = .returnAction
        returnButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        returnButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        editLabel.text = "Notes:"
        editLabel.textColor = .textColor
        editLabel.font = UIFont.systemFont(ofSize: .textSize)

        editTextView.isScrollEnabled = false
        editTextView.textColor = .textColor
        editTextView.backgroundColor = .backgroundTextFieldColor
        editTextView.font = UIFont.systemFont(ofSize: .textSize)

        priorityLabel.text = "Priority:"
        priorityLabel.textColor = .textColor
        priorityLabel.font = UIFont.systemFont(ofSize: .textSize)

        priorityStackView.axis = .horizontal
        priorityStackView.distribution = .fillEqually
        priorityStackView.spacing = 5.0

        lowPriorityButton.type = .lowPriority
        lowPriorityButton.setTitle("Low", for: .normal)
        lowPriorityButton.setTitleColor(.lowPriorityColor, for: .normal)
        lowPriorityButton.setTitleColor(UIColor.white, for: .selected)
        lowPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        lowPriorityButton.backgroundColor = .lowPriorityColor
        lowPriorityButton.layer.cornerRadius = 15.0
        lowPriorityButton.layer.borderColor = UIColor.lowPriorityColor.cgColor
        lowPriorityButton.layer.borderWidth = .buttonBorderWidth
        lowPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        mediumPriorityButton.type = .mediumPriority
        mediumPriorityButton.setTitle("Medium", for: .normal)
        mediumPriorityButton.setTitleColor(.mediumPriorityColor, for: .normal)
        mediumPriorityButton.setTitleColor(UIColor.white, for: .selected)
        mediumPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        mediumPriorityButton.backgroundColor = .mediumPriorityColor
        mediumPriorityButton.layer.cornerRadius = 15.0
        mediumPriorityButton.layer.borderColor = UIColor.mediumPriorityColor.cgColor
        mediumPriorityButton.layer.borderWidth = .buttonBorderWidth
        mediumPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        highPriorityButton.type = .highPriority
        highPriorityButton.setTitle("High", for: .normal)
        highPriorityButton.setTitleColor(.highPriorityColor, for: .normal)
        highPriorityButton.setTitleColor(UIColor.white, for: .selected)
        highPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        highPriorityButton.backgroundColor = .highPriorityColor
        highPriorityButton.layer.cornerRadius = 15.0
        highPriorityButton.layer.borderColor = UIColor.highPriorityColor.cgColor
        highPriorityButton.layer.borderWidth = .buttonBorderWidth
        highPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        alarmLabel.text = "Alarm:"
        alarmLabel.textColor = .textColor
        alarmLabel.font = UIFont.systemFont(ofSize: .textSize)

        alarmDateTimeLabel.text = "Test Date at Test Time"
        alarmDateTimeLabel.textColor = .textSecondaryColor
        alarmDateTimeLabel.font = UIFont.systemFont(ofSize: .textSize)
        alarmDateTimeLabel.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(alarmLabelTapped))
        alarmDateTimeLabel.addGestureRecognizer(tap)

        alarmPicker.datePickerMode = .dateAndTime

        setup(detail: nil, priority: Priority.low, isSubreminder: false)

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
        actionButtonStackView.addArrangedSubview(subreminderButton)
        actionButtonStackView.addArrangedSubview(returnButton)


        // Setup Constraints

        // Silences UIView-Encapsulated-Layout-Height constraint error
        let bottomConstraint = actionCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .cellYSpacingInverse)
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.setupAndActivate(constraints: [
            actionCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .cellXSpacing),
            actionCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .cellXSpacingInverse),
            actionCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .cellYSpacing),
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

    func setup(detail: String?, priority: Priority?, isSubreminder: Bool) {
        editTextView.text = detail ?? ""

        lowPriorityButton.isSelected = true
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

        self.isSubreminder = isSubreminder
        alarmIsExpanded = false
        changeModeViews(.returnAction)
    }

    func getDetailText() -> String {
        return editTextView.text
    }

    func getAlarmDate() -> Date {
        return alarmPicker.date
    }

    @objc private func selectPriority(_ selected: UICellButton) {
        delegate?.didTapButton(cell: self, type: selected.type)
        for view in priorityStackView.arrangedSubviews {
            guard let button = view as? UICellButton else {
                return
            }

            if button === selected {
                button.isSelected = true

                if button.type == .lowPriority {
                    button.backgroundColor = .lowPriorityColor
                } else if button.type == .mediumPriority {
                    button.backgroundColor = .mediumPriorityColor
                } else if button.type == .highPriority {
                    button.backgroundColor = .highPriorityColor
                }
            } else {
                button.isSelected = false
                button.backgroundColor = UIColor.clear
            }
        }
    }

    @objc private func alarmLabelTapped() {
        print("Tapped")
        alarmIsExpanded = !alarmIsExpanded
        self.alarmPicker.isHidden = !self.alarmIsExpanded
        delegate?.didTapButton(cell: self, type: .alarmLabel)
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

            subreminderButton.isHidden = isSubreminder ? true : false

        default:
            break
        }

        if type != .returnAction {
            returnButton.isHidden = false
            editTextButton.isHidden = true
            changePriorityButton.isHidden = true
            setAlarmButton.isHidden = true
            subreminderButton.isHidden = true
        }
    }
}
