//
//  CreateMomentViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/15/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class CreateReminderViewController: UIViewController {

    var exitGestureRecognizer: UITapGestureRecognizer!
    var cardGestureRecognizer: UIPanGestureRecognizer!
    var reminderCardView: UIView!
    var originalCardCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        cardGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardGestureRecognized))
        reminderCardView?.addGestureRecognizer(cardGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        originalCardCenter = reminderCardView.center
        print("Reminder card:", reminderCardView.frame, reminderCardView.center)
    }

    func setupLayout() {
        self.view.backgroundColor = UIColor(white: 0.7, alpha: 0.7)

        reminderCardView = UIView()
        self.view.addSubview(reminderCardView)

        reminderCardView.backgroundColor = UIColor.white
        reminderCardView.layer.cornerRadius = 10
        reminderCardView.layer.shadowOffset = CGSize.zero
        reminderCardView.layer.shadowRadius = 25
        reminderCardView.layer.shadowOpacity = 0.25

        let viewMargins = self.view.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            reminderCardView.widthAnchor.constraint(equalTo: viewMargins.widthAnchor, multiplier: 0.8),
            reminderCardView.heightAnchor.constraint(equalTo: viewMargins.heightAnchor, multiplier: 0.7),
            reminderCardView.centerXAnchor.constraint(equalTo: viewMargins.centerXAnchor),
            reminderCardView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor)])

        let cardMargins = reminderCardView.layoutMarginsGuide

        let dateLabel = UILabel()
        reminderCardView.addSubview(dateLabel)
        dateLabel.text = "11/02/94"
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = dateLabel.font.withSize(10.0)
        dateLabel.textAlignment = .center

        NSLayoutConstraint.setupAndActivate(constraints: [
            dateLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: reminderCardView.topAnchor, constant: Constants.spacingCGFloat),
            dateLabel.heightAnchor.constraint(equalToConstant: 15.0)])

        let detailsField = UITextView()
        reminderCardView.addSubview(detailsField)
//        detailsField.text

        NSLayoutConstraint.setupAndActivate(constraints: [
            detailsField.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
            detailsField.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
            detailsField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.spacingCGFloat)])

        self.view.layoutSubviews()
    }

    @objc func cardGestureRecognized(gesture: UIPanGestureRecognizer) {
        if let cardView = gesture.view {
            let translation = gesture.translation(in: self.view)
            cardView.center = CGPoint(x: cardView.center.x + translation.x, y: cardView.center.y)

            if gesture.state == .ended {

                let horizontalVelocity = gesture.velocity(in: self.view).x * 0.001
                print("Horizontal Velocity:", horizontalVelocity)

                if horizontalVelocity < -1.0 {
                    print("Push back")
                } else if horizontalVelocity > 1.0 {
                    print("Completed")
                } else {
                    if cardView.center.x <= self.view.bounds.width * 0.15 {
                        print("Push back")

                    } else if cardView.center.x >= self.view.bounds.width * 0.85  {
                        print("Completed")
                    }
                    else {
                        print("nothing")
                    }
                }

                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.originalCardCenter
                })
            }

        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
}
