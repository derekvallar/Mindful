//
//  UIReminderCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderCellDelegate: class {
    func didTapReminderButton(_ cell: UIReminderCell, type: UIReminderButtonType)
}

class UIReminderCell: UITableViewCell {

    weak var buttonDelegate: UIReminderCellDelegate?

    private var cellStackView = UIStackView()
    private var branchImage = UIImageView()
    private var reminderView = UIReminderView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.clear

        branchImage.isHidden = true
        cellStackView.alignment = .center
        reminderView.buttonDelegate = self

        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(branchImage)
        cellStackView.addArrangedSubview(reminderView)

        NSLayoutConstraint.setupAndActivate(constraints: [
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .cellXSpacing),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .cellXSpacingInverse),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .cellYSpacing),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .cellYSpacingInverse),
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if !selected {
            reminderView.titleTextView.isUserInteractionEnabled = false
        }
    }

    func getTitleText() -> String {
        return reminderView.getTitleText()
    }

    func isCompleted() -> Bool {
        return reminderView.isCompleted()
    }

    func setUserInteraction(_ bool: Bool) {
        reminderView.titleTextView.isUserInteractionEnabled = bool
    }

    func setTitleDelegate(controller: UIViewController) {
        if let controller = controller as? MainReminderViewController {
            reminderView.titleTextView.delegate = controller.self
        }
        return
    }

    func titleViewBecomeFirstResponder() {
        reminderView.titleTextView.becomeFirstResponder()
    }

    func changeFilterMode(_ filtering: Bool) {
        reminderView.changeFilterMode(filtering)
    }

    func setup(item: ReminderViewModelItem, filtering: Bool, lastSubreminder: Bool) {
        reminderView.setup(item: item, filtering: filtering)

        if item.isSubreminder {
            branchImage.isHidden = false
            branchImage.image = lastSubreminder ? #imageLiteral(resourceName: "SubreminderEndIcon") : #imageLiteral(resourceName: "SubreminderBranchIcon")
        } else {
            branchImage.isHidden = true
        }
    }
}

extension UIReminderCell: UIReminderViewDelegate {

    func didTapButton(type: UIReminderButtonType) {
        buttonDelegate?.didTapReminderButton(self, type: type)
    }
}
