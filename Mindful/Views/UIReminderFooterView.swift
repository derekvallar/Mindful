//
//  UIReminderFooterView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/30/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderFooterViewDelegate: class {
    func didTapReturn()
}

class UIReminderFooterView: UITableViewHeaderFooterView {

    weak var delegate: UIReminderFooterViewDelegate?

    let containerView = UICellButton()
    let returnImage = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        containerView.type = .returnAction
        containerView.addTarget(self, action: #selector(returnTapped), for: .touchUpInside)

        returnImage.image = #imageLiteral(resourceName: "TestIcon")

        contentView.addSubview(containerView)
        containerView.addSubview(returnImage)

        NSLayoutConstraint.setupAndActivate(constraints: [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40.0)
            ])

        NSLayoutConstraint.setupAndActivate(constraints: [
            returnImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            returnImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    @objc func returnTapped() {
        delegate?.didTapReturn()
    }
}
