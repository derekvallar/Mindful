//
//  ActionIndices.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 1/3/18.
//  Copyright © 2018 Derek Vallar. All rights reserved.
//

import Foundation

struct ActionIndices {
    private var selected: IndexPath?
    private var category: IndexPath?
    private var action: IndexPath?
    private var back: IndexPath?

    mutating func setSelected(to index: IndexPath, withCategory: Bool) {
        selected = index

        if withCategory {
            var categoryIndex = index
            categoryIndex.row += 1
            category = categoryIndex
        }
    }

    mutating func clearSelected() {
        selected = nil
        category = nil
        action = nil
    }

    mutating func setAction() {
        guard let _ = selected,
              let categoryCellIndex = category else {
            return
        }

        var newCategoryIndex = categoryCellIndex
        newCategoryIndex.row += 1

        action = categoryCellIndex
        self.category = newCategoryIndex
    }

    mutating func clearAction() {
        category = action
        action = nil
    }

    mutating func setReturn() {
        back = selected
    }

    mutating func clearReturn() {
        back = nil
    }

    func getSelected() -> IndexPath? {
        return selected
    }

    func getCategory() -> IndexPath? {
        return category
    }

    func getAction() -> IndexPath? {
        return action
    }

    func getReturn() -> IndexPath? {
        return back
    }

    func getExpandedCellCount() -> Int {
        var count = 0
        if category != nil {
            count += 1
        }
        if action != nil {
            count += 1
        }
        return count
    }
}
