//
//  NewReminderView.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/16/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class CreateReminderView: UIView {

    private let borderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.backgroundColor = UIColor.darkGray

        let margins = self.layoutMarginsGuide
        let reminderView = UIView()
        reminderView.backgroundColor = UIColor.blue
        self.addSubview(reminderView)

        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            reminderView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            reminderView.heightAnchor.constraint(equalToConstant: 70.0),
            reminderView.centerYAnchor.constraint(equalTo: margins.centerYAnchor)])

        print("Bounds:", reminderView.bounds)
        layoutIfNeeded()
        print("Bounds2:", reminderView.bounds)
        let path = UIBezierPath(roundedRect: reminderView.bounds, cornerRadius: 10.0)
        borderLayer.path = path.cgPath

        borderLayer.lineWidth = 3.0
        borderLayer.lineDashPattern = [10,10]
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = nil

        reminderView.layer.addSublayer(borderLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
