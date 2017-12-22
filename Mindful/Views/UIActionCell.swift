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

        editLabel.text = "Detail:"
        editLabel.textColor = Constants.textColor
        editLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        editTextView.isScrollEnabled = false
        editTextView.textColor = Constants.textSecondaryColor
        editTextView.backgroundColor = Constants.backgroundTextFieldColor
        editTextView.font = UIFont.systemFont(ofSize: Constants.textSize)

        priorityLabel.text = "Priority:"
        priorityLabel.textColor = Constants.textColor
        priorityLabel.font = UIFont.systemFont(ofSize: Constants.textSize)

        priorityStackView.axis = .horizontal
        priorityStackView.distribution = .fillEqually
        priorityStackView.spacing = 5.0

        let lowPriorityButton = UICellButton()
        lowPriorityButton.type = .lowPriority
        lowPriorityButton.setTitle("Low", for: .normal)
        lowPriorityButton.setTitleColor(UIColor.white, for: .normal)
        lowPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)
        lowPriorityButton.backgroundColor = Constants.lowPriorityColor
        lowPriorityButton.layer.cornerRadius = 15.0

        let mediumPriorityButton = UICellButton()
        mediumPriorityButton.type = .mediumPriority
        mediumPriorityButton.setTitle("Medium", for: .normal)
        mediumPriorityButton.setTitleColor(UIColor.white, for: .normal)
        mediumPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)
        mediumPriorityButton.backgroundColor = Constants.mediumPriorityColor
        mediumPriorityButton.layer.cornerRadius = 15.0

        let highPriorityButton = UICellButton()
        highPriorityButton.type = .highPriority
        highPriorityButton.setTitle("High", for: .normal)
        highPriorityButton.setTitleColor(UIColor.white, for: .normal)
        highPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.textSize)
        highPriorityButton.backgroundColor = Constants.highPriorityColor
        highPriorityButton.layer.cornerRadius = 15.0


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

        NSLayoutConstraint.setupAndActivate(constraints: [
            actionCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellXSpacing),
            actionCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cellXSpacingInverse),
            actionCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellYSpacing),
            actionCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cellYSpacingInverse)
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
        }

        if let priority = priority {
            
        }

        changeModeViews(.returnAction)
    }

    func getDetailText() -> String {
        return editTextView.text
    }

    func getAlarmDate() -> Date {
        return alarmPicker.date
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
