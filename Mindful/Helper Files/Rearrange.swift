//
//  Rearrange.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/29/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

struct Rearrange {
    var cell: UITableViewCell?
    var snapshotView: UIView?
    var snapshotOffset: CGFloat?
    var currentIndexPath: IndexPath?

    init(cell: UITableViewCell, snapshotView: UIView, snapshotOffset: CGFloat, currentIndexPath: IndexPath) {
        self.cell = cell
        self.snapshotView = snapshotView
        self.snapshotOffset = snapshotOffset
        self.currentIndexPath = currentIndexPath
    }

    mutating func clear() {
        snapshotView?.removeFromSuperview()
        cell = nil
        snapshotView = nil
        snapshotOffset = nil
        currentIndexPath = nil
    }
}
