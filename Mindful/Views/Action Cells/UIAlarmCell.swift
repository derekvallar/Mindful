//
//  UIAlarmCell.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/2/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import UIKit

class UIAlarmCell: UITableViewCell {

    weak var delegate: UIActionCellDelegate?

    private var alarmStackView = UIStackView()
    private var onOffStackView = UIStackView()
    private var alarmLabel = UILabel()
    private var alarmOffButton = UICellButton()
    private var alarmOnButton = UICellButton()
    private var alarmDateTimeLabel = UILabel()
    private var alarmPicker = UIDatePicker()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("Initing action cell")

        // Setup Variables

        alarmLabel.text = "Alarm:"
        alarmLabel.textColor = .textColor
        alarmLabel.font = UIFont.systemFont(ofSize: .textSize)

        alarmDateTimeLabel.text = "Test Date at Test Time"
        alarmDateTimeLabel.textColor = .textSecondaryColor
        alarmDateTimeLabel.font = UIFont.systemFont(ofSize: .textSize)
        alarmDateTimeLabel.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(alarmLabelTapped))
        alarmDateTimeLabel.addGestureRecognizer(tap)

        alarmPicker.datePickerMode = .dateAndTime

        alarmStackView.addArrangedSubview(onOffStackView)
        alarmStackView.addArrangedSubview(alarmDateTimeLabel)
        alarmStackView.addArrangedSubview(alarmPicker)

        onOffStackView.addArrangedSubview(alarmLabel)
        onOffStackView.addArrangedSubview(alarmOffButton)
        onOffStackView.addArrangedSubview(alarmOnButton)
    }

    func setup() {
        alarmPicker.isHidden = true
    }

    func getAlarmDate() -> Date {
        return alarmPicker.date
    }

    @objc private func alarmLabelTapped(label: UICellButton) {
        print("Tapped")
        alarmPicker.isHidden = !alarmPicker.isHidden
        delegate?.didTapActionButton(type: label.type)
    }
}
