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
    var detailLabel = UILabel()
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

        detailLabel.text = "Created 5 hours ago"
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = detailLabel.font.withSize(14.0)
        cardView.addSubview(detailLabel)

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
            detailLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor, constant: 10.0),
            detailLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: cardMargins.bottomAnchor, constant: -10.0),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0)])

    }

    func setup(withTitle title: String?, detail: String?) {
        titleLabel.text = title
        detailLabel.text = detail
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
