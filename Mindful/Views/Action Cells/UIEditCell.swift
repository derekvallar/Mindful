//
//  UIEditCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIEditCellTextDelegate: class {
    func detailTextDidChange()
    func detailTextDidEndEditing(_ cell: UIEditCell)
}

class UIEditCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?
    weak var textDelegate: UIEditCellTextDelegate?

    private var editStackView = UIStackView()
    private var editLabel = UILabel()
    private var editTextView = UITextView()
    private var editTextViewBorder = UIView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.white
        clipsToBounds = true
        
        editStackView.axis = .vertical
        editStackView.distribution = .fill

        editLabel.text = "Notes:"
        editLabel.textColor = .textColor
        editLabel.font = UIFont.systemFont(ofSize: .reminderTextSize)

        editTextView.isScrollEnabled = false
        editTextView.textColor = .textColor
//        editTextView.backgroundColor = .backgroundTextFieldColor
        editTextView.font = UIFont.systemFont(ofSize: .reminderTextSize)
        editTextView.delegate = self

        editTextViewBorder.backgroundColor = UIColor.lightGray

        contentView.addSubview(editStackView)
        editStackView.addArrangedSubview(editLabel)
        editStackView.addArrangedSubview(editTextView)
        editStackView.addArrangedSubview(editTextViewBorder)

        NSLayoutConstraint.setupAndActivate(constraints: [
            editStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .actionCellLeading),
            editStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .actionCellTrailing),
            editStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .actionCellTop),
            editStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .actionCellBottom),
        ])

        NSLayoutConstraint.setupAndActivate(constraints: [
            editTextViewBorder.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }

    func setup(detail: String?) {
        editTextView.text = detail ?? ""
    }

    func getDetailText() -> String {
        return editTextView.text
    }
}

extension UIEditCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDelegate?.detailTextDidChange()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textDelegate?.detailTextDidEndEditing(self)
    }
}
