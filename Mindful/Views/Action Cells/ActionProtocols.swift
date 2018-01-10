//
//  UIActionCellDelegate.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

protocol UIActionCellDelegate: class {
    func didTapActionButton(type: UIReminderButtonType)
}
