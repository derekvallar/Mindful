//
//  UIReminderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/28/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol UIReminderViewDelegate: class {
    func didTapButton(button: UIReminderButtonType)
}

class UIReminderView: UIView {

    weak var buttonDelegate: UIReminderViewDelegate?

    private var cardView = UIView()
    private var cardStackView = UIStackView()

    private var reminderStackView = UIStackView()
    private var leftButton = UICellButton()
    private var rearrangeImage = UIImageView()
    private var subreminderButton = UICellButton()

    private var infoStackView = UIStackView()
    private var priorityImageView = UIImageView()
    private var alarmLabel = UILabel()
    private var detailLabel = UILabel()

    private var filterMode = false

    var titleTextView = UITextView()

    init() {
        super.init(frame: CGRect.zero)
        // Setup Views
        
        backgroundColor = UIColor.white
        
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 7.0
        cardView.layer.borderColor = UIColor.mediumPriorityColor.cgColor
        
        cardStackView.axis = .vertical
        cardStackView.spacing = .viewSpacing
        
        reminderStackView.axis = .horizontal
        reminderStackView.spacing = .viewSpacing
        reminderStackView.alignment = .center
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        leftButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        rearrangeImage.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        subreminderButton.addTarget(self, action: #selector(subreminderButtonPressed), for: .touchUpInside)
        subreminderButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        infoStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)
        
        titleTextView.textColor = .textColor
        titleTextView.isScrollEnabled = false
        titleTextView.isUserInteractionEnabled = false
        titleTextView.font = UIFont.systemFont(ofSize: .textSize)
        titleTextView.textContainerInset = UIEdgeInsets.zero
        titleTextView.textContainer.lineFragmentPadding = 0.0
        titleTextView.layer.masksToBounds = false
        
        alarmLabel.isHidden = true
        
        detailLabel.isHidden = true
        detailLabel.textColor = .textSecondaryColor
        detailLabel.font = UIFont.systemFont(ofSize: .textSecondarySize)
        
        rearrangeImage.image = #imageLiteral(resourceName: "RearrangeIcon")
        rearrangeImage.isHidden = true
        
        subreminderButton.type = .subreminder
        subreminderButton.setImage(#imageLiteral(resourceName: "SubreminderIcon"), for: .normal)
        subreminderButton.isHidden = true
        
        
        // Add Subviews
        
        self.addSubview(cardView)
        cardView.addSubview(cardStackView)
        
        cardStackView.addArrangedSubview(reminderStackView)
        
        reminderStackView.addArrangedSubview(leftButton)
        reminderStackView.addArrangedSubview(infoStackView)
        reminderStackView.addArrangedSubview(subreminderButton)
        reminderStackView.addArrangedSubview(rearrangeImage)
        
        infoStackView.addArrangedSubview(titleTextView)
        infoStackView.addArrangedSubview(detailLabel)
        
        
        // Setup Constraints
        
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .cellXSpacing),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .cellXSpacingInverse),
            cardView.topAnchor.constraint(equalTo: self.topAnchor, constant: .cellYSpacing),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .cellYSpacingInverse)
            ])
        
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: .viewSpacing),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: .viewSpacingInverse),
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: .layoutSpacing),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: .layoutSpacingInverse)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func leftButtonPressed() {
        if filterMode {

        } else {
            leftButton.isSelected = !leftButton.isSelected
        }

        buttonDelegate?.didTapButton(button: leftButton.type)
    }

    @objc func subreminderButtonPressed() {
        if !filterMode {
            buttonDelegate?.didTapButton(button: subreminderButton.type)
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
            rearrangeImage.isHidden = false
        } else {
            rearrangeImage.isHidden = true
        }
    }

    func changeFilterMode(_ filtering: Bool) {
        filterMode = filtering
        if filterMode {
            leftButton.isSelected = false
            subreminderButton.isEnabled = false

            if rearrangeImage.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rearrangeImage.isHidden = false
                })
            }
        } else {
            subreminderButton.isEnabled = true
            if !rearrangeImage.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.rearrangeImage.isHidden = true
                })
            }
        }

        UIView.animate(withDuration: 0.075, animations: {
            self.leftButton.alpha = 0.0
            self.rearrangeImage.alpha = 0.0
        }) { (_) in
            self.synchronizeButtonImages()
            UIView.animate(withDuration: 0.075, animations: {
                self.leftButton.alpha = 1.0
                self.rearrangeImage.alpha = 1.0
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

    private func synchronizeButtonImages() {
        if filterMode {
            leftButton.type = .delete
            leftButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
            leftButton.setImage(nil, for: .selected)
        } else {
            leftButton.type = .complete
            leftButton.setImage(#imageLiteral(resourceName: "CompleteIndicator"), for: .normal)
            leftButton.setImage(#imageLiteral(resourceName: "CheckedCompleteIndicator"), for: .selected)
        }
    }
}
