//
//  Constants.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

enum Constants {

    // MARK: Strings

    static let appName = "Mindful"
    static let mainTitle = "Reminders"
    static let filterTitle = "Filter Reminders"
    static let completedTitle = "Completed"
    static let subreminderTitle = "Subreminders"

    static let reminderCellIdentifier = "ReminderCell"
    static let actionCellIdentifier = "ActionCell"

    static let emptyIconString: String = "EmptyIcon"
    static let priorityIconString: String = "PriorityIcon"
    static let highPriorityIconString: String = "HighPriorityIcon"

    static let completeDeleteButtonString: String = "completeDeleteButtonString"
    static let detailRearrangeButtonString: String = "detailRearrangeButtonString"


    // MARK: Numbers

    static let textSize: CGFloat = 14.5
    static let textSecondarySize: CGFloat = 12.5

    static let actionViewSpacing: CGFloat = 10.0
    static let viewSpacing: CGFloat = 8.0
    static let viewSpacingInverse: CGFloat = -8.0
    static let layoutSpacing: CGFloat = 12.0
    static let layoutSpacingInverse: CGFloat = -12.0

    static let cellXSpacing: CGFloat = 10.0
    static let cellXSpacingInverse: CGFloat = -10.0
    static let cellYSpacing: CGFloat = 5.0
    static let cellYSpacingInverse: CGFloat = -5.0

    static let buttonBorderWidth: CGFloat = 2.0

    static let estimatedReminderRowHeight: CGFloat = 60.5
    static let estimatedActionRowHeight: CGFloat = 36.5
    static let estimatedSmallExpandedActionRowHeight: CGFloat = 105.0
    static let estimatedLargeExpandedActionRowHeight: CGFloat = 317.5

    // MARK: Colors

    static let backgroundColor: UIColor = #colorLiteral(red: 0.5198073602, green: 0.8550287484, blue: 0.9985881448, alpha: 1)
    static let gradientColor: UIColor = #colorLiteral(red: 0, green: 0.529114902, blue: 0.7376316786, alpha: 1)
    static let backgroundTextFieldColor: UIColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.8235294118, alpha: 1)

    static let textColor: UIColor = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2078431373, alpha: 1)
    static let textSecondaryColor: UIColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
    static let textWrittenSecondaryColor: UIColor = #colorLiteral(red: 0.6094480939, green: 0.6154822334, blue: 0.6154822334, alpha: 1)
    static let textCompletedColor: UIColor = #colorLiteral(red: 1, green: 0.8235294118, blue: 0.3921568627, alpha: 1)

    static let lowPriorityColor: UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    static let mediumPriorityColor: UIColor = #colorLiteral(red: 1, green: 0.7450980392, blue: 0.3921568627, alpha: 1)
    static let highPriorityColor: UIColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.431372549, alpha: 1)
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






