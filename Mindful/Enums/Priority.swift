//
//  Priority.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 10/6/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import Foundation

enum Priority: Int16 {
    case none, priority, highPriority

    var imageLocation: String {
        switch self {
        case .none:
            return Constants.emptyIconString
        case .priority:
            return Constants.priorityIconString
        case .highPriority:
            return Constants.highPriorityIconString
        }
    }
}
