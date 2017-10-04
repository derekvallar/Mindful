//
//  ReminderTableCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    var cardView = UIView()
    var titleLabel = UILabel()
    var remindDateLabel = UILabel()
    var descriptionLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup subviews

        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.lightGray
//        titleLabel.backgroundColor = UIColor.blue
//        remindDateLabel.backgroundColor = UIColor.green

        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 5.0
        self.contentView.addSubview(cardView)

        titleLabel.text = "Pick up sushi"
        cardView.addSubview(titleLabel)

        remindDateLabel.text = "Created 5 hours ago"
        remindDateLabel.textColor = UIColor.lightGray
        remindDateLabel.font = remindDateLabel.font.withSize(14.0)
        cardView.addSubview(remindDateLabel)

        // Setup Constraints

        let cellMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: cellMargins.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cellMargins.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: cellMargins.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: cellMargins.bottomAnchor)])

        let cardMargins = cardView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cardMargins.topAnchor, constant: 10.0),
            titleLabel.bottomAnchor.constraint(equalTo: cardMargins.centerYAnchor, constant: -2.5)])

        NSLayoutConstraint.setupAndActivate(constraints: [
            remindDateLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor, constant: 10.0),
            remindDateLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            remindDateLabel.bottomAnchor.constraint(equalTo: cardMargins.bottomAnchor, constant: -10.0),
            remindDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0)])

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
