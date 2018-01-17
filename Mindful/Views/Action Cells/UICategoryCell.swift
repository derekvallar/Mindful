//
//  UIActionCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/18/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UICategoryCellDelegate: class {
    func didTapCategoryButton(type: UIReminderButtonType)
}

class UICategoryCell: UITableViewCell {

    weak var delegate: UICategoryCellDelegate?

    private var categoryStackView = UIStackView()
    private var editTextButton = UICellButton()
    private var changePriorityButton = UICellButton()
    private var setAlarmButton = UICellButton()
    private var subreminderButton = UICellButton()
    private var returnButton = UICellButton()

    private var isSubreminder = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup Variables

        selectionStyle = .none
        backgroundColor = UIColor.white
        clipsToBounds = true

        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .fillEqually
        categoryStackView.alignment = .center

        editTextButton.type = .category(type: .edit)
        editTextButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        editTextButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        changePriorityButton.type = .category(type: .priority)
        changePriorityButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        changePriorityButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        setAlarmButton.type = .category(type: .alarm)
        setAlarmButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        setAlarmButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        subreminderButton.type = .category(type: .subreminders)
        subreminderButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        subreminderButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        returnButton.type = .category(type: .back)
        returnButton.setImage(#imageLiteral(resourceName: "TestIcon"), for: .normal)
        returnButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)

        setup(isSubreminder: false, showCategories: true)

        // Setup Subviews

        contentView.addSubview(categoryStackView)
        categoryStackView.addArrangedSubview(editTextButton)
        categoryStackView.addArrangedSubview(changePriorityButton)
        categoryStackView.addArrangedSubview(setAlarmButton)
        categoryStackView.addArrangedSubview(subreminderButton)
        categoryStackView.addArrangedSubview(returnButton)


        // Setup Constraints

        // Silences UIView-Encapsulated-Layout-Height constraint error
        let bottomConstraint = categoryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .actionCellBottom)
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.setupAndActivate(constraints: [
            categoryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .actionCellLeading),
            categoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .actionCellTrailing),
            categoryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .actionCellTop),
            bottomConstraint,
            categoryStackView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }

    @objc func actionPressed(button: UICellButton) {
        guard case let .category(type) = button.type else {
            return
        }
        if type == .back {
            showCategories(true)
        } else {
            showCategories(false)
        }
        delegate?.didTapCategoryButton(type: button.type)
    }

    func setup(isSubreminder: Bool, showCategories show: Bool) {
        print("Setting up cat cell")
        self.isSubreminder = isSubreminder
        showCategories(show)

        editTextButton.alpha = 1.0
        changePriorityButton.alpha = 1.0
        setAlarmButton.alpha = 1.0
        subreminderButton.alpha = 1.0

        animateShowCategories(withSubreminder: true)
    }

    private func showCategories(_ show: Bool) {
        if show {
            returnButton.isHidden = true
            editTextButton.isHidden = false
            changePriorityButton.isHidden = false
            setAlarmButton.isHidden = false
            subreminderButton.isHidden = isSubreminder ? true : false
        } else {
            returnButton.isHidden = false
            editTextButton.isHidden = true
            changePriorityButton.isHidden = true
            setAlarmButton.isHidden = true
            subreminderButton.isHidden = true
        }
    }

    func animateShowCategories(withSubreminder: Bool) {
        editTextButton.frame.origin.y -= 40.0
        changePriorityButton.frame.origin.y -= 40.0
        setAlarmButton.frame.origin.y -= 40.0
        subreminderButton.frame.origin.y -= 40.0

        let duration = 0.4

        UIView.animate(withDuration: duration, animations: {
            self.editTextButton.frame.origin.y += 40.0
        }, completion: nil)

        UIView.animate(withDuration: duration, delay: 0.04, options: [], animations: {
            self.changePriorityButton.frame.origin.y += 40.0
        }, completion: nil)

        UIView.animate(withDuration: duration, delay: 0.08, options: [], animations: {
            self.setAlarmButton.frame.origin.y += 40.0
        }, completion: nil)

        UIView.animate(withDuration: duration, delay: 0.12, options: [], animations: {
            self.subreminderButton.frame.origin.y += 40.0
        }, completion: nil)
    }

    func animateHideCategories(withSubreminder: Bool) {
        let duration = 0.3

        UIView.animate(withDuration: duration, animations: {
            self.editTextButton.frame.origin.y -= 40.0
        }, completion: { _ in
            self.editTextButton.frame.origin.y += 40.0
        })

        UIView.animate(withDuration: duration, delay: 0.04, options: [], animations: {
            self.changePriorityButton.frame.origin.y -= 40.0
        }, completion: { _ in
            self.changePriorityButton.frame.origin.y += 40.0
        })

        UIView.animate(withDuration: duration, delay: 0.08, options: [], animations: {
            self.setAlarmButton.frame.origin.y -= 40.0
        }, completion: { _ in
            self.setAlarmButton.frame.origin.y += 40.0
        })

        UIView.animate(withDuration: duration, delay: 0.12, options: [], animations: {
            self.subreminderButton.frame.origin.y -= 40.0
        }, completion: { _ in
            self.subreminderButton.frame.origin.y += 40.0
        })
    }
}
