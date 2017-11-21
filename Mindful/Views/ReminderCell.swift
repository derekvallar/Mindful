//
//  ReminderTableCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol CellButtonDelegate: class {
    func didTapButton(_ cell: ReminderCell, button: String)
}

class ReminderCell: UITableViewCell {

    weak var buttonDelegate: CellButtonDelegate?

    private var cardView = UIView()
    private var cardStackView = UIStackView()

    private var completeDeleteButton = UIButton()
    private var detailRearrangeButton = UIButton()

    private var infoStackView = UIStackView()
    private var priorityImage = UIImageView()
    private var alarmLabel = UILabel()
    private var detailLabel = UILabel()

    private var filterMode = false

    var titleField = UITextField()

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

        completeDeleteButton.tag = 0
        completeDeleteButton.addTarget(self, action: #selector(completeDeleteButtonPressed), for: .touchUpInside)

        detailRearrangeButton.tag = 1
        detailRearrangeButton.addTarget(self, action: #selector(detailRearrangeButtonPressed), for: .touchUpInside)

        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = -3.0
        infoStackView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)

        titleField.textColor = Constants.textColor
        titleField.isUserInteractionEnabled = false

        detailLabel.textColor = Constants.textSecondaryColor
        detailLabel.font = detailLabel.font.withSize(14.0)

        detailRearrangeButton.isHidden = true

        // Setup Constraints

        contentView.addSubview(cardView)

        let cellMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: cellMargins.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cellMargins.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: cellMargins.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: cellMargins.bottomAnchor)])

        cardView.addSubview(cardStackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.viewSpacing),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: Constants.viewSpacingInverse),
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.viewSpacing),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: Constants.viewSpacingInverse)])

        cardStackView.addArrangedSubview(completeDeleteButton)
        cardStackView.addArrangedSubview(infoStackView)
        cardStackView.addArrangedSubview(detailRearrangeButton)
        NSLayoutConstraint.setupAndActivate(constraints: [
            completeDeleteButton.widthAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.5)])

        infoStackView.addArrangedSubview(titleField)
        infoStackView.addArrangedSubview(detailLabel)
    }

    func setup(withTitle title: String, detail: String, image: UIImage, filtering: Bool) {
        titleField.text = title
        detailLabel.text = detail
        priorityImage.image = image
        filterMode = filtering

        synchronizeButtonImages()
    }

    func changeFilterMode(_ filtering: Bool) {
        filterMode = filtering

        if filterMode {
            completeDeleteButton.isSelected = false
        }

        UIView.animate(withDuration: 0.075, animations: {
            self.completeDeleteButton.alpha = 0.0
            self.detailRearrangeButton.alpha = 0.0
        }) { (finished) in
            self.synchronizeButtonImages()
            UIView.animate(withDuration: 0.075, animations: {
                self.completeDeleteButton.alpha = 1.0
                self.detailRearrangeButton.alpha = 1.0
            })
        }
    }

    func userSelected(_ selected: Bool) {

        UIView.animate(withDuration: 0.15) {
            self.detailRearrangeButton.alpha = selected ? 1.0 : 0.0
            self.detailRearrangeButton.isHidden = !selected
        }

        if selected {
            titleField.isUserInteractionEnabled = true
            titleField.becomeFirstResponder()
        } else {
            titleField.isUserInteractionEnabled = false
        }
    }


    @objc func completeDeleteButtonPressed() {
        if filterMode {

        } else {
            completeDeleteButton.isSelected = !completeDeleteButton.isSelected
        }

        buttonDelegate?.didTapButton(self, button: Constants.completeDeleteButtonString)
    }

    @objc func detailRearrangeButtonPressed() {
        buttonDelegate?.didTapButton(self, button: Constants.detailRearrangeButtonString)
    }

    private func synchronizeButtonImages() {
        if filterMode {
            completeDeleteButton.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: .normal)
            completeDeleteButton.setImage(nil, for: .selected)
            detailRearrangeButton.setImage(#imageLiteral(resourceName: "RearrangeIcon"), for: .normal)
            detailRearrangeButton.isHidden = false
        } else {
            completeDeleteButton.setImage(#imageLiteral(resourceName: "Indicator"), for: .normal)
            completeDeleteButton.setImage(#imageLiteral(resourceName: "Checked Indicator"), for: .selected)
            detailRearrangeButton.setImage(#imageLiteral(resourceName: "DetailIcon"), for: .normal)
            detailRearrangeButton.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
