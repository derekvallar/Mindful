//
//  UIReminderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/28/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderViewDelegate: class {
    func didTapButton(type: UIReminderButtonType)
}

class UIReminderView: UIView {

    weak var buttonDelegate: UIReminderViewDelegate?

    private var reminderStackView = UIStackView()
    private var completeDeleteButton = UICellButton()
    private var rearrangeIcon = UIImageView()
    private var subreminderIcon = UIImageView()

    private var infoStackView = UIStackView()
    private var alarmLabel = UILabel()
    private var detailLabel = UILabel()

    private var filterMode = false

    var titleTextView = UITextView()

    init() {
        super.init(frame: CGRect.zero)
        // Setup Views

        backgroundColor = UIColor.white

        
        reminderStackView.axis = .horizontal
        reminderStackView.spacing = .reminderStackViewLeading
        reminderStackView.alignment = .center

        completeDeleteButton.addTarget(self, action: #selector(completeDeleteButtonPressed), for: .touchUpInside)
        completeDeleteButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)

//completeDeleteButton.backgroundColor = UIColor.blue

        rearrangeIcon.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        subreminderIcon.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        infoStackView.spacing = 3.0
        infoStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)
        
        titleTextView.textColor = .textColor
        titleTextView.isScrollEnabled = false
        titleTextView.isUserInteractionEnabled = false
        titleTextView.font = UIFont.systemFont(ofSize: .reminderTextSize)
        titleTextView.textContainerInset = UIEdgeInsets.zero
        titleTextView.textContainer.lineFragmentPadding = 0.0
        titleTextView.layer.masksToBounds = false
        
        alarmLabel.isHidden = true
        alarmLabel.textColor = .textSecondaryColor
        alarmLabel.font = UIFont.systemFont(ofSize: .textSecondarySize)
        alarmLabel.clipsToBounds = true

        detailLabel.isHidden = true
        detailLabel.textColor = .textSecondaryColor
        detailLabel.font = UIFont.systemFont(ofSize: .textSecondarySize)
        
        rearrangeIcon.image = #imageLiteral(resourceName: "RearrangeIcon")
        rearrangeIcon.isHidden = true
        
        subreminderIcon.image = #imageLiteral(resourceName: "SubreminderIcon")
        subreminderIcon.isHidden = true
        
        // Add Subviews
        
        self.addSubview(reminderStackView)
        reminderStackView.addArrangedSubview(completeDeleteButton)
        reminderStackView.addArrangedSubview(infoStackView)
        reminderStackView.addArrangedSubview(subreminderIcon)
        reminderStackView.addArrangedSubview(rearrangeIcon)
        
        infoStackView.addArrangedSubview(titleTextView)
        infoStackView.addArrangedSubview(alarmLabel)
        infoStackView.addArrangedSubview(detailLabel)

        
        // Setup Constraints

        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reminderStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            reminderStackView.topAnchor.constraint(equalTo: self.topAnchor),
            reminderStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.setupAndActivate(constraints: [
            completeDeleteButton.widthAnchor.constraint(equalToConstant: 40.0),
            completeDeleteButton.heightAnchor.constraint(equalTo: reminderStackView.heightAnchor, multiplier: 1.0),
            completeDeleteButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40.0)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func completeDeleteButtonPressed() {
        if filterMode {

        } else {
            completeDeleteButton.isSelected = !completeDeleteButton.isSelected
        }

        buttonDelegate?.didTapButton(type: completeDeleteButton.type)
    }

    func setup(reminder: Reminder, filtering: Bool) {
        completeDeleteButton.isSelected = reminder.completed
        titleTextView.text = reminder.title

        if let date = reminder.alarmDate as Date? {
            setAlarmText(text: date.getText())
        }
        setDetailText(text: reminder.detail)

        subreminderIcon.isHidden = !reminder.hasSubreminders()
        filterMode = filtering
        rearrangeIcon.isHidden = filterMode ? false : true
        synchronizeButtonImages()
    }

    func changeFilterMode(_ filtering: Bool) {
        filterMode = filtering
        if filterMode {
            completeDeleteButton.isSelected = false

            if rearrangeIcon.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rearrangeIcon.isHidden = false
                })
            }
        } else {
            if !rearrangeIcon.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rearrangeIcon.isHidden = true
                })
            }
        }

        UIView.animate(withDuration: 0.075, animations: {
            self.completeDeleteButton.alpha = 0.0
            self.rearrangeIcon.alpha = 0.0
        }) { (_) in
            self.synchronizeButtonImages()
            UIView.animate(withDuration: 0.075, animations: {
                self.completeDeleteButton.alpha = 1.0
                self.rearrangeIcon.alpha = 1.0
            })
        }
    }

    func getTitleText() -> String {
        return titleTextView.text
    }

    func isCompleted() -> Bool {
        return completeDeleteButton.isSelected
    }

    func setAlarmText(text: String) {
        alarmLabel.text = text
        alarmLabel.isHidden = text == "" ? true : false
    }

    func setDetailText(text: String) {
        detailLabel.text = text
        detailLabel.isHidden = text == "" ? true : false
    }

    private func synchronizeButtonImages() {
        if filterMode {
            completeDeleteButton.type = .reminder(type: .delete)
            completeDeleteButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
            completeDeleteButton.setImage(nil, for: .selected)
        } else {
            completeDeleteButton.type = .reminder(type: .complete)
            completeDeleteButton.setImage(#imageLiteral(resourceName: "CompleteIndicator"), for: .normal)
            completeDeleteButton.setImage(#imageLiteral(resourceName: "CheckedCompleteIndicator"), for: .selected)
        }
    }
}
