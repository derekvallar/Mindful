//
//  UISeparatorLine.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/11/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class UISeparatorLine: UIView {

    init(withColor color: UIColor, height: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = color
        NSLayoutConstraint.setupAndActivate(constraints: [self.heightAnchor.constraint(equalToConstant: height)])
        self.layer.cornerRadius = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
