//
//  UIReminderCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderCellDelegate: class {
    func didTapReminderButton(_ cell: UIReminderCell, type: UIReminderButtonType)
}

protocol UIReminderCellTextDelegate: class {
    func titleTextDidChange(_ textView: UITextView)
    func titleTextDidEndEditing(_ cell: UIReminderCell)
}

class UIReminderCell: UITableViewCell {

    weak var buttonDelegate: UIReminderCellDelegate?
    weak var textDelegate: UIReminderCellTextDelegate?

    private var cellStackView = UIStackView()
    private var branchImage = UIImageView()
    private var reminderView = UIReminderView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.white

        cellStackView.alignment = .center
        cellStackView.spacing = .reminderStackViewLeading

        branchImage.isHidden = true
        reminderView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        reminderView.buttonDelegate = self
        reminderView.titleTextView.delegate = self
        reminderView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reminderView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(branchImage)
        cellStackView.addArrangedSubview(reminderView)

        NSLayoutConstraint.setupAndActivate(constraints: [
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .reminderStackViewLeading),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .reminderStackViewTrailing),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .reminderStackViewTop),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .reminderStackViewBottom)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if !selected {
            reminderView.titleTextView.isUserInteractionEnabled = false
        }
    }

    func getTitleText() -> String {
        return reminderView.getTitleText()
    }

    func isCompleted() -> Bool {
        return reminderView.isCompleted()
    }

    func setTitleText(text: String) {
        reminderView.titleTextView.text = text
    }

    func setAlarmText(text: String) {
        reminderView.setAlarmText(text: text)
    }

    func setDetailText(text: String) {
        reminderView.setDetailText(text: text)
    }

    func setUserInteraction(_ bool: Bool) {
        reminderView.titleTextView.isUserInteractionEnabled = bool
    }

    func titleViewBecomeFirstResponder() {
        reminderView.titleTextView.becomeFirstResponder()
    }

    func changeFilterMode(_ filtering: Bool) {
        reminderView.changeFilterMode(filtering)
    }

    func editMode(_ isEditing: Bool) {
        reminderView.editMode(isEditing)
    }

    func setup(reminder: Reminder, filtering: Bool, lastSubreminder: Bool) {
        reminderView.setup(reminder: reminder, filter: filtering)

        if reminder.isSubreminder {
            branchImage.isHidden = false
            branchImage.image = lastSubreminder ? #imageLiteral(resourceName: "SubreminderEndIcon") : #imageLiteral(resourceName: "SubreminderBranchIcon")
        } else {
            branchImage.isHidden = true
        }
    }
}

extension UIReminderCell: UIReminderViewDelegate {
    func didTapButton(type: UIReminderButtonType) {
        buttonDelegate?.didTapReminderButton(self, type: type)
    }
}

extension UIReminderCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDelegate?.titleTextDidChange(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textDelegate?.titleTextDidEndEditing(self)
    }
}
