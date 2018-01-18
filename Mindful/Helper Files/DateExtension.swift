//
//  DateExtension.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/17/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

extension Date {
    func getText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
