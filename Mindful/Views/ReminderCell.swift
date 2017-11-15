//
//  ReminderTableCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/3/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

protocol DeleteIndicatorDelegate: class {
    func didTapIndicator(_ cell: ReminderCell, selected: Bool)
}

class ReminderCell: UITableViewCell {

    weak var indicatorDelegate: DeleteIndicatorDelegate?

    var cardView = UIView()
    var titleField = UITextField()
    var detailLabel = UILabel()
    var descriptionLabel = UILabel()
    var deletionIndicator = UIButton()

    var oldTitle: String!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup views
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear

        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 7.0
//        cardView.layer.shadowOffset = CGSize.zero
//        cardView.layer.shadowRadius = 4.0
//        cardView.layer.shadowOpacity = 0.2

        titleField.text = ""
        titleField.textColor = Constants.textColor

        detailLabel.text = "Created now"
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = detailLabel.font.withSize(14.0)

        deletionIndicator.setImage(#imageLiteral(resourceName: "Indicator"), for: .normal)
        deletionIndicator.setImage(#imageLiteral(resourceName: "Checked Indicator"), for: .selected)
        deletionIndicator.addTarget(self, action: #selector(deleteIndicatorPressed), for: .touchUpInside)
    }

    func setup(withTitle title: String?, detail: String?, filterMode: Bool) {
        titleField.text = title
        detailLabel.text = detail

        self.contentView.addSubview(cardView)

        let cellMargins = contentView.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardView.leadingAnchor.constraint(equalTo: cellMargins.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cellMargins.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: cellMargins.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: cellMargins.bottomAnchor)])

        let cardStackView = UIStackView()
        cardStackView.axis = .horizontal
        cardStackView.spacing = 5.0
        cardStackView.backgroundColor = UIColor.blue

        cardView.addSubview(cardStackView)
        NSLayoutConstraint.setupAndActivate(constraints: [
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10.0),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10.0),
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10.0),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10.0)])

        cardStackView.addArrangedSubview(deletionIndicator)
        NSLayoutConstraint.setupAndActivate(constraints: [
            deletionIndicator.widthAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.5)])

        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = -3.0

        cardStackView.addArrangedSubview(infoStackView)

        infoStackView.addArrangedSubview(titleField)
        infoStackView.addArrangedSubview(detailLabel)

        deletionIndicator.alpha = filterMode ? 1.0 : 0.0
        deletionIndicator.isHidden = !filterMode
    }

    func showDeletionIndicator(_ bool: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.deletionIndicator.alpha = bool ? 1.0 : 0.0
            self.deletionIndicator.isHidden = !bool
        }
    }

    func setDeletionIndicator(to set: Bool) {
        self.deletionIndicator.isSelected = set
    }

    @objc func deleteIndicatorPressed() {
        deletionIndicator.isSelected = !deletionIndicator.isSelected
        indicatorDelegate?.didTapIndicator(self, selected: deletionIndicator.isSelected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
