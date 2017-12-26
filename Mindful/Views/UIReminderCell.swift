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

    private var cardView = UIView()
    private var cardStackView = UIStackView()
    private var borderLayer: CAShapeLayer?

    private var reminderStackView = UIStackView()
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
        cardView.layer.borderColor = Constants.mediumPriorityColor.cgColor

        cardStackView.axis = .vertical
        cardStackView.spacing = Constants.viewSpacing

        reminderStackView.axis = .horizontal
        reminderStackView.spacing = Constants.viewSpacing
        reminderStackView.alignment = .center

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
        titleTextView.font = UIFont.systemFont(ofSize: Constants.textSize)
        titleTextView.textContainerInset = UIEdgeInsets.zero
        titleTextView.textContainer.lineFragmentPadding = 0.0
        titleTextView.layer.masksToBounds = false

        alarmLabel.isHidden = true
        
        detailLabel.isHidden = true
        detailLabel.textColor = Constants.textSecondaryColor
        detailLabel.font = UIFont.systemFont(ofSize: Constants.textSecondarySize)
        
        rightButton.isHidden = true

        subreminderButton.type = .subreminder
        subreminderButton.setImage(#imageLiteral(resourceName: "SubreminderIcon"), for: .normal)
        subreminderButton.isHidden = true


        // Add Subviews

        contentView.addSubview(cardView)
        cardView.addSubview(cardStackView)

        cardStackView.addArrangedSubview(reminderStackView)

        reminderStackView.addArrangedSubview(leftButton)
        reminderStackView.addArrangedSubview(infoStackView)
        reminderStackView.addArrangedSubview(subreminderButton)
        reminderStackView.addArrangedSubview(rightButton)

        infoStackView.addArrangedSubview(titleTextView)
        infoStackView.addArrangedSubview(detailLabel)


        // Setup Constraints

        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.cellXSpacing),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.cellXSpacingInverse),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.cellYSpacing),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cellYSpacingInverse)
        ])

        NSLayoutConstraint.setupAndActivate(constraints: [
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.viewSpacing),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: Constants.viewSpacingInverse),
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.layoutSpacing),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.layoutSpacingInverse)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.15) {
            self.rightButton.alpha = selected ? 1.0 : 0.0
            self.rightButton.isHidden = !selected
        }

        titleTextView.isUserInteractionEnabled = selected
        if selected {
            titleTextView.becomeFirstResponder()
            cardView.layer.borderWidth = 5.0
        } else {
            cardView.layer.borderWidth = 0.0
        }
    }

    func setup(item: ReminderViewModelItem, filtering: Bool) {
        leftButton.isSelected = item.completed
        titleTextView.text = item.title
        if let detailText = item.detail {
            detailLabel.isHidden = false
            detailLabel.text = detailText
        }
        priorityImageView.image = UIImage(named: item.priority.imageLocation)

        subreminderButton.isHidden = !item.hasSubreminders
        filterMode = filtering
        synchronizeButtonImages()
        
        if filterMode {
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
        }
    }

    func changeFilterMode(_ filtering: Bool) {
        filterMode = filtering
        if filterMode {
            leftButton.isSelected = false
            subreminderButton.isEnabled = false
            
            if rightButton.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rightButton.isHidden = false
                })
            }
        } else {
            subreminderButton.isEnabled = true
            if !rightButton.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rightButton.isHidden = true
                })
            }
        }

        UIView.animate(withDuration: 0.075, animations: {
            self.leftButton.alpha = 0.0
            self.rightButton.alpha = 0.0
        }) { (_) in
            self.synchronizeButtonImages()
            UIView.animate(withDuration: 0.075, animations: {
                self.leftButton.alpha = 1.0
                self.rightButton.alpha = 1.0
            })
        }
    }

    func getTitleText() -> String {
        return titleTextView.text
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
        if !filterMode {
            buttonDelegate?.didTapButton(self, button: subreminderButton.type)
        }
    }

    private func synchronizeButtonImages() {
        if filterMode {
            leftButton.type = .delete
            leftButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
            leftButton.setImage(nil, for: .selected)

            rightButton.type = .rearrange
            rightButton.setImage(#imageLiteral(resourceName: "RearrangeIcon"), for: .normal)
        } else {
            leftButton.type = .complete
            leftButton.setImage(#imageLiteral(resourceName: "CompleteIndicator"), for: .normal)
            leftButton.setImage(#imageLiteral(resourceName: "CheckedCompleteIndicator"), for: .selected)

            rightButton.type = .detail
            rightButton.setImage(#imageLiteral(resourceName: "DetailIcon"), for: .normal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
