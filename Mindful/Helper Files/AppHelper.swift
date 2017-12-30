//
//  .swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

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






