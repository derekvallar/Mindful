//
//  UICellButton.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/5/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class UICellButton: UIButton {

    var type = UICellButtonType.none

    func setType(_ type: UICellButtonType) {
        self.type = type
    }
}
