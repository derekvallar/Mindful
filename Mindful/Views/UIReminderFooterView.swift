//
//  UIReminderFooterView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/30/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class UIReminderFooterView: UITableViewHeaderFooterView {

    let containerView = UICellButton()
    let returnImage = UIImageView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        containerView.type = .returnAction
//        containerView.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        containerView.backgroundColor = UIColor.blue

        returnImage.image = #imageLiteral(resourceName: "TestIcon")

        contentView.addSubview(containerView)
        containerView.addSubview(returnImage)

        NSLayoutConstraint.setupAndActivate(constraints: [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

//        NSLayoutConstraint.setupAndActivate(constraints: [
//            returnImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            returnImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
//            returnImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5.0)
//        ])
    }
}
