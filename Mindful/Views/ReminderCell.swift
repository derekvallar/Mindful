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
    var titleField = UITextField()
    var detailLabel = UILabel()
    var descriptionLabel = UILabel()

    var oldTitle: String!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup subviews
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
//        titleLabel.backgroundColor = UIColor.blue
//        remindDateLabel.backgroundColor = UIColor.green

        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 7.0
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowRadius = 4.0
        cardView.layer.shadowOpacity = 0.2
        self.contentView.addSubview(cardView)

        titleField.text = "Pick up sushi"
        titleField.textColor = Constants.textColor
        cardView.addSubview(titleField)

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
            cardView.bottomAnchor.constraint(equalTo: cellMargins.bottomAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 70.0)])

        let cardMargins = cardView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            titleField.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor, constant: 10.0),
            titleField.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            titleField.bottomAnchor.constraint(equalTo: cardMargins.centerYAnchor, constant: -2.5)])

        NSLayoutConstraint.setupAndActivate(constraints: [
            detailLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor, constant: 10.0),
            detailLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 5.0)])

    }

    func setup(withTitle title: String?, detail: String?) {
        titleField.text = title
        detailLabel.text = detail
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
