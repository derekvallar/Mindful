//
//  CreateMomentViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/15/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class DetailedReminderViewController: UIViewController {

    var detailedReminderView: UIView!

    var exitGestureRecognizer: UITapGestureRecognizer!
    var cardGestureRecognizer: UIPanGestureRecognizer!
    var originalCardCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0.7, alpha: 0.7)

        detailedReminderView = DetailedReminderView(frame: CGRect.zero)
        self.view.addSubview(detailedReminderView)

        let viewMargins = self.view.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
            detailedReminderView.widthAnchor.constraint(equalTo: viewMargins.widthAnchor, multiplier: 0.95),
            detailedReminderView.heightAnchor.constraint(equalTo: viewMargins.heightAnchor, multiplier: 0.7),
            detailedReminderView.centerXAnchor.constraint(equalTo: viewMargins.centerXAnchor),
            detailedReminderView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor)])


//        cardGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardGestureRecognized))
//        detailedReminderView.addGestureRecognizer(cardGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        originalCardCenter = detailedReminderView.center
        print("Reminder card:", detailedReminderView.frame, detailedReminderView.center)
    }


//    @objc func cardGestureRecognized(gesture: UIPanGestureRecognizer) {
//        if let cardView = gesture.view {
//            let translation = gesture.translation(in: self.view)
//            cardView.center = CGPoint(x: cardView.center.x + translation.x, y: cardView.center.y)
//
//            if gesture.state == .ended {
//
//                let horizontalVelocity = gesture.velocity(in: self.view).x * 0.001
//                print("Horizontal Velocity:", horizontalVelocity)
//
//                if horizontalVelocity < -1.0 {
//                    print("Push back")
//                } else if horizontalVelocity > 1.0 {
//                    print("Completed")
//                } else {
//                    if cardView.center.x <= self.view.bounds.width * 0.15 {
//                        print("Push back")
//
//                    } else if cardView.center.x >= self.view.bounds.width * 0.85  {
//                        print("Completed")
//                    }
//                    else {
//                        print("nothing")
//                    }
//                }
//
//                UIView.animate(withDuration: 0.2, animations: {
//                    cardView.center = self.originalCardCenter
//                })
//            }
//
//        }
//        gesture.setTranslation(CGPoint.zero, in: self.view)
//    }
}
