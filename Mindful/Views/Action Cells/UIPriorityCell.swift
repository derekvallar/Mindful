//
//  UIPriorityCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

class UIPriorityCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?

    private var priorityStackView = UIStackView()
    private var priorityLabel = UILabel()
    private var buttonStackView = UIStackView()
    private var lowPriorityButton = UICellButton()
    private var mediumPriorityButton = UICellButton()
    private var highPriorityButton = UICellButton()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        // Setup Variables

        priorityLabel.text = "Priority:"
        priorityLabel.textColor = .textColor
        priorityLabel.font = UIFont.systemFont(ofSize: .textSize)

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 5.0

        lowPriorityButton.type = UIReminderButtonType.action(type: .lowPriority)
        lowPriorityButton.setTitle("Low", for: .normal)
        lowPriorityButton.setTitleColor(.lowPriorityColor, for: .normal)
        lowPriorityButton.setTitleColor(UIColor.white, for: .selected)
        lowPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        lowPriorityButton.backgroundColor = .lowPriorityColor
        lowPriorityButton.layer.cornerRadius = 15.0
        lowPriorityButton.layer.borderColor = UIColor.lowPriorityColor.cgColor
        lowPriorityButton.layer.borderWidth = .buttonBorderWidth
        lowPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        mediumPriorityButton.type = UIReminderButtonType.action(type: .mediumPriority)
        mediumPriorityButton.setTitle("Medium", for: .normal)
        mediumPriorityButton.setTitleColor(.mediumPriorityColor, for: .normal)
        mediumPriorityButton.setTitleColor(UIColor.white, for: .selected)
        mediumPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        mediumPriorityButton.backgroundColor = .mediumPriorityColor
        mediumPriorityButton.layer.cornerRadius = 15.0
        mediumPriorityButton.layer.borderColor = UIColor.mediumPriorityColor.cgColor
        mediumPriorityButton.layer.borderWidth = .buttonBorderWidth
        mediumPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)

        mediumPriorityButton.type = UIReminderButtonType.action(type: .highPriority)
        highPriorityButton.setTitle("High", for: .normal)
        highPriorityButton.setTitleColor(.highPriorityColor, for: .normal)
        highPriorityButton.setTitleColor(UIColor.white, for: .selected)
        highPriorityButton.titleLabel?.font = UIFont.systemFont(ofSize: .textSize)

        highPriorityButton.backgroundColor = .highPriorityColor
        highPriorityButton.layer.cornerRadius = 15.0
        highPriorityButton.layer.borderColor = UIColor.highPriorityColor.cgColor
        highPriorityButton.layer.borderWidth = .buttonBorderWidth
        highPriorityButton.addTarget(self, action: #selector(selectPriority), for: .touchUpInside)


        priorityStackView.addArrangedSubview(priorityLabel)
        priorityStackView.addArrangedSubview(priorityStackView)
        
        buttonStackView.addArrangedSubview(lowPriorityButton)
        buttonStackView.addArrangedSubview(mediumPriorityButton)
        buttonStackView.addArrangedSubview(highPriorityButton)
    }

    func setup(priority: Priority) {
        lowPriorityButton.isSelected = false
        mediumPriorityButton.isSelected = false
        highPriorityButton.isSelected = false

        if priority == Priority.high {
            highPriorityButton.isSelected = true
        } else if priority == Priority.medium {
            mediumPriorityButton.isSelected = true
        } else {
            lowPriorityButton.isSelected = true
        }
    }

    @objc private func selectPriority(selected: UICellButton) {

        delegate?.didTapActionButton(type: selected.type)
        for view in buttonStackView.arrangedSubviews {
            guard let button = view as? UICellButton,
                case let .action(priority) = button.type else {
                return
            }

            if button === selected {
                button.isSelected = true
                switch priority {
                case .lowPriority:
                    button.backgroundColor = .lowPriorityColor
                case .mediumPriority:
                    button.backgroundColor = .mediumPriorityColor
                case .highPriority:
                    button.backgroundColor = .highPriorityColor
                default:
                    break
                }
            } else {
                button.isSelected = false
                button.backgroundColor = UIColor.clear
            }
        }
    }

}
