//
//  UIEditCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

class UIEditCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?

    private var editStackView = UIStackView()
    private var editLabel = UILabel()
    private var editTextView = UITextView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        editLabel.text = "Notes:"
        editLabel.textColor = .textColor
        editLabel.font = UIFont.systemFont(ofSize: .textSize)

        editTextView.isScrollEnabled = false
        editTextView.textColor = .textColor
        editTextView.backgroundColor = .backgroundTextFieldColor
        editTextView.font = UIFont.systemFont(ofSize: .textSize)

        editStackView.addArrangedSubview(editLabel)
        editStackView.addArrangedSubview(editTextView)

        NSLayoutConstraint.setupAndActivate(constraints: [
            editStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            editStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            editStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            editStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func setup(detail: String?) {
        editTextView.text = detail ?? ""
    }

    func getDetailText() -> String {
        return editTextView.text
    }
}
