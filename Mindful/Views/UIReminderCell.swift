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

        branchImage.isHidden = true
        cellStackView.alignment = .center
        reminderView.buttonDelegate = self
        reminderView.titleTextView.delegate = self

        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(branchImage)
        cellStackView.addArrangedSubview(reminderView)

        NSLayoutConstraint.setupAndActivate(constraints: [
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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

    func setup(reminder: Reminder, filtering: Bool, lastSubreminder: Bool) {
        reminderView.setup(reminder: reminder, filtering: filtering)

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
    func textViewDidEndEditing(_ textView: UITextView) {
        textDelegate?.titleTextDidEndEditing(self)
    }
}
