//
//  UIReminderHeaderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/29/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class UIReminderHeaderView: UITableViewHeaderFooterView {

    let reminderView = UIReminderView()
//    containerView.backgroundColor = UIColor.cyan


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(reuseIdentifier: String?, item: ReminderViewModelItem) {
        super.init(reuseIdentifier: reuseIdentifier)

        reminderView.setup(item: item, filtering: false)

        contentView.addSubview(reminderView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reminderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reminderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reminderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
