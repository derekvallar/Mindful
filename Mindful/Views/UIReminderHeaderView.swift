//
//  UIReminderHeaderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/29/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderHeaderViewDelegate: class {
    func didTapHeaderButton(type: UIReminderButtonType)
}

class UIReminderHeaderView: UITableViewHeaderFooterView {

    weak var delegate: UIReminderHeaderViewDelegate?

    let reminderView = UIReminderView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.white
        reminderView.buttonDelegate = self

        contentView.addSubview(reminderView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .reminderStackViewLeading),
            reminderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .reminderStackViewTrailing),
            reminderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .reminderStackViewTop),
            reminderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .reminderStackViewBottom)
            ])
    }

    func setup(reminder: Reminder) {
        reminderView.setup(reminder: reminder, filtering: false)
    }

    func isCompleted() -> Bool {
        return reminderView.isCompleted()
    }
}

extension UIReminderHeaderView: UIReminderViewDelegate {
    func didTapButton(type: UIReminderButtonType) {
        delegate?.didTapHeaderButton(type: type)
    }
}
