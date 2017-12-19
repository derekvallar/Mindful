//
//  ActionCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/18/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    private var actionStackView = UIStackView()
    private var editTextButton = UICellButton()
    private var changePriorityButton = UICellButton()
    private var setAlarmButton = UICellButton()
    private var addSubreminderButton = UICellButton()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        actionStackView.axis = .horizontal
        actionStackView.distribution = .fillEqually

        editTextButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        changePriorityButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        setAlarmButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        addSubreminderButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)

        actionStackView.addArrangedSubview(editTextButton)
        actionStackView.addArrangedSubview(changePriorityButton)
        actionStackView.addArrangedSubview(setAlarmButton)
        actionStackView.addArrangedSubview(addSubreminderButton)

        NSLayoutConstraint.setupAndActivate(constraints: [
            actionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellXSpacing),
            actionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cellXSpacingInverse),
            actionStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellYSpacing),
            actionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cellYSpacingInverse)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
