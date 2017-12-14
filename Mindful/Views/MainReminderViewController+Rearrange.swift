//
//  MainReminderViewController+Rearrange.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController {
    
    func rearrangeLongPress(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let location = longPress.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return }
        let cell = tableView.cellForRow(at: indexPath)
        
        
        switch longPress.state {
        case .began:
            
            break
        case .changed:
            break
        case .ended, .possible, .cancelled, .failed:
            break
        }
    }
    
    private func snapshot(cell: UIView) -> UIView {
        UIGraphicsBeginImageContext(cell.bounds.size)
        
        return UIView()
    }
}
