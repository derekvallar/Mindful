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

        reminderView.buttonDelegate = self

        contentView.addSubview(reminderView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reminderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reminderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reminderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }

    func setup(item: ReminderViewModelItem) {
        reminderView.setup(item: item, filtering: false)
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
