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
    static let spacingCGFloat: CGFloat = 10.0
}

extension NSLayoutConstraint {

    public class func setupAndActivate(constraints: [NSLayoutConstraint]) {
        if let view = constraints.first?.firstItem as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
            activate(constraints)
        }
    }
}
