//
//  ReminderTableCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol CellButtonDelegate: class {
    func didTapButton(_ cell: ReminderCell, button: UICellButtonType)
}

class ReminderCell: UITableViewCell {

    weak var buttonDelegate: CellButtonDelegate?

    private var cardView = UIView()
    private var cardStackView = UIStackView()

    private var leftButton = UICellButton()
    private var rightButton = UICellButton()
    private var subreminderButton = UICellButton()

    private var infoStackView = UIStackView()
    private var priorityImageView = UIImageView()
    private var alarmLabel = UILabel()
    private var detailLabel = UILabel()

    private var filterMode = false

    var titleTextView = UITextView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup Views

        selectionStyle = .none
        backgroundColor = UIColor.clear

        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 7.0

        cardStackView.axis = .horizontal
        cardStackView.spacing = Constants.viewSpacing
        cardStackView.alignment = .center

        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        leftButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)

        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        rightButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)

        subreminderButton.addTarget(self, action: #selector(subreminderButtonPressed), for: .touchUpInside)
        subreminderButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)

        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        infoStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)

        titleTextView.textColor = Constants.textColor
        titleTextView.isScrollEnabled = false
        titleTextView.isUserInteractionEnabled = false
        titleTextView.font = UIFont.systemFont(ofSize: 14.5)
        titleTextView.textContainerInset = UIEdgeInsets.zero
        titleTextView.textContainer.lineFragmentPadding = 0.0

        alarmLabel.isHidden = true
        detailLabel.isHidden = true
        detailLabel.textColor = Constants.textSecondaryColor
        detailLabel.font = detailLabel.font.withSize(12.5)

        rightButton.isHidden = true

        subreminderButton.setImage(#imageLiteral(resourceName: "SubreminderIcon"), for: .normal)
        subreminderButton.setType(.subreminder)
        subreminderButton.isHidden = true

        // Setup Constraints

        contentView.addSubview(cardView)

        let cellMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellXSpacing),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cellXSpacingInverse),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellYSpacing),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cellYSpacingInverse)
            ])

        cardView.addSubview(cardStackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.viewSpacing),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: Constants.viewSpacingInverse),
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.layoutSpacing),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.layoutSpacingInverse)])

        cardStackView.addArrangedSubview(leftButton)
        cardStackView.addArrangedSubview(infoStackView)
        cardStackView.addArrangedSubview(subreminderButton)
        cardStackView.addArrangedSubview(rightButton)

        infoStackView.addArrangedSubview(titleTextView)
        infoStackView.addArrangedSubview(detailLabel)
    }

    func setup(item: ReminderViewModelItem, hasSubreminders: Bool, filtering: Bool) {

        leftButton.isSelected = item.completed
        titleTextView.text = item.title
        if let detailText = item.detail {
            detailLabel.isHidden = false
            detailLabel.text = detailText
        }
        priorityImageView.image = UIImage(named: item.priority.imageLocation)

        subreminderButton.isHidden = !hasSubreminders
        filterMode = filtering

        synchronizeButtonImages()
    }

    func changeFilterMode(_ filtering: Bool) {
        filterMode = filtering
        if filterMode {
            leftButton.isSelected = false
        }

        UIView.animate(withDuration: 0.075, animations: {
            self.leftButton.alpha = 0.0
            self.rightButton.alpha = 0.0
        }) { (finished) in
            self.synchronizeButtonImages()
            UIView.animate(withDuration: 0.075, animations: {
                self.leftButton.alpha = 1.0
                self.rightButton.alpha = 1.0
            })
        }
    }

    func userSelected(_ selected: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.rightButton.alpha = selected ? 1.0 : 0.0
            self.rightButton.isHidden = !selected
        }

        titleTextView.isUserInteractionEnabled = selected
        if selected {
            titleTextView.becomeFirstResponder()
        }
    }

    func isCompleted() -> Bool? {
        if !filterMode {
            return leftButton.isSelected
        }
        return nil
    }

    @objc func leftButtonPressed() {
        if filterMode {

        } else {
            leftButton.isSelected = !leftButton.isSelected
        }

        buttonDelegate?.didTapButton(self, button: leftButton.type)
    }

    @objc func rightButtonPressed() {
        buttonDelegate?.didTapButton(self, button: rightButton.type)
    }

    @objc func subreminderButtonPressed() {
        buttonDelegate?.didTapButton(self, button: subreminderButton.type)
    }

    private func synchronizeButtonImages() {
        if filterMode {
            leftButton.setType(.delete)
            leftButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
            leftButton.setImage(nil, for: .selected)

            rightButton.setType(.rearrange)
            rightButton.setImage(#imageLiteral(resourceName: "RearrangeIcon"), for: .normal)
            rightButton.isHidden = false
        } else {
            leftButton.setType(.complete)
            leftButton.setImage(#imageLiteral(resourceName: "CompleteIndicator"), for: .normal)
            leftButton.setImage(#imageLiteral(resourceName: "CheckedCompleteIndicator"), for: .selected)

            rightButton.setType(.delete)
            rightButton.setImage(#imageLiteral(resourceName: "DetailIcon"), for: .normal)
            rightButton.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
