//
//  Constants.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

enum Constants {
    static let appName = "Mindful"

    static let viewSpacing: CGFloat = 5.0
    static let viewSpacingInverse: CGFloat = -5.0
    static let layoutSpacing: CGFloat = 15.0
    static let layoutSpacingInverse: CGFloat = -15.0

    static let cellHeight: CGFloat = 85.0

    static let backgroundColor: UIColor = #colorLiteral(red: 0.6077729797, green: 0.8089405031, blue: 0.9985881448, alpha: 1)
    static let gradientColor: UIColor = #colorLiteral(red: 0, green: 0.529114902, blue: 0.7376316786, alpha: 1)
    static let textColor: UIColor = #colorLiteral(red: 0.2068527919, green: 0.2068527919, blue: 0.2068527919, alpha: 1)
    static let textSecondaryColor: UIColor = #colorLiteral(red: 0.7597485179, green: 0.7672707804, blue: 0.7672707804, alpha: 1)
    static let textWrittenSecondaryColor: UIColor = #colorLiteral(red: 0.6094480939, green: 0.6154822334, blue: 0.6154822334, alpha: 1)

    static let emptyIconString: String = "EmptyIcon"
    static let priorityIconString: String = "PriorityIcon"
    static let highPriorityIconString: String = "HighPriorityIcon"

    static let completeDeleteButtonString: String = "completeDeleteButtonString"
    static let detailRearrangeButtonString: String = "detailRearrangeButtonString"
}

extension NSLayoutConstraint {

    public class func setupAndActivate(constraints: [NSLayoutConstraint]) {
        if let view = constraints.first?.firstItem as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        activate(constraints)
    }
}

extension UIView {

    func gradient(_ firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame  = self.bounds

        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension TimeInterval {

    static let secondsToDays = 86400.0
    static let secondsToHours = 3600.0
    static let secondsToMinutes = 60.0

    func toDays() -> Int {
        return Int((self / .secondsToDays).nextDown)
    }

    func toHours() -> Int {
        return Int((self / .secondsToHours).nextDown)
    }

    func toMinutes() -> Int {
        return Int((self / .secondsToMinutes).nextDown)
    }
}






