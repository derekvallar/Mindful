//
//  Priority.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/6/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

enum Priority: Int16 {
    case low, medium, high

    var imageLocation: String {
        switch self {
        case .low:
            return Constants.emptyIconString
        case .medium:
            return Constants.priorityIconString
        case .high:
            return Constants.highPriorityIconString
        }
    }
}
