//
//  UIReminderCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderCellDelegate: class {
    func didTapButton(_ cell: UIReminderCell, button: UIReminderButtonType)
}

class UIReminderCell: UITableViewCell {

    weak var buttonDelegate: UIReminderCellDelegate?

    private var cellStackView = UIStackView()
     var branchImage = UIImageView()
    private var reminderView = UIReminderView()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.clear

        branchImage.isHidden = true
//        branchImage.backgroundColor = UIColor.blue
//        reminderView.backgroundColor = UIColor.cyan

        cellStackView.alignment = .center
//        cellStackView.distribution
//        branchImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        branchImage.setContentHuggingPriority(.defaultHigh, for: .vertical)

//        branchImage.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        reminderView.buttonDelegate = self


        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(branchImage)
        cellStackView.addArrangedSubview(reminderView)

//        NSLayoutConstraint.setupAndActivate(constraints: [
//            branchImage.widthAnchor.constraint(equalToConstant: 75.0)])

        NSLayoutConstraint.setupAndActivate(constraints: [
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

//        NSLayoutConstraint.setupAndActivate(constraints: [
//            reminderView.leadingAnchor.constraint(equalTo: branchImage.trailingAnchor),
//            reminderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            reminderView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            reminderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("branchimage:", branchImage.bounds.height)


        if !selected {
            reminderView.titleTextView.isUserInteractionEnabled = false
        }
    }

    func getTitleText() -> String {
        return reminderView.getTitleText()
    }

    func isCompleted() -> Bool {
        if let completed = reminderView.isCompleted() {
            return completed
        }
        return false
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

    func setup(item: ReminderViewModelItem, filtering: Bool, endSub: Bool) {
        print("Item:", item.title)
        reminderView.setup(item: item, filtering: filtering)

        if item.isSubreminder {
            branchImage.isHidden = false
            branchImage.image = endSub ? #imageLiteral(resourceName: "SubreminderEndIcon") : #imageLiteral(resourceName: "SubreminderBranchIcon")
        }
    }
}

extension UIReminderCell: UIReminderViewDelegate {

    func didTapButton(button: UIReminderButtonType) {
        buttonDelegate?.didTapButton(self, button: button)
    }
}
