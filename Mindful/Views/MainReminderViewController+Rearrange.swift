//
//  MainReminderViewController+Rearrange.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 12/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

extension MainReminderViewController {

    @objc func rearrangeLongPress(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let location = longPress.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        switch longPress.state {
        case .began:
            let view = snapshot(cell: cell)
            view.center = cell.center
            view.alpha = 0.0
            tableView.addSubview(view)

            UIView.animate(withDuration: 0.25, animations: {
                view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                view.alpha = 1.0
            }, completion: { (finished) in
                if finished {
                    cell.isHidden = true
                }
            })

            Rearrange.snapshotView = view
            Rearrange.snapshotOffset = location.y - view.center.y
            Rearrange.currentIndexPath = indexPath

        case .changed:
            guard let snapshotView = Rearrange.snapshotView,
                  let currentIndexPath = Rearrange.currentIndexPath else {
                return
            }
            
            if snapshotView.alpha == 1.0 {
                snapshotView.alpha = 0.9
            }
            
            snapshotView.center.y = location.y - Rearrange.snapshotOffset!
            
            if currentIndexPath != indexPath {
                tableView.moveRow(at: currentIndexPath, to: indexPath)
                viewModel.swapReminders(fromIndexPath: currentIndexPath, to: indexPath)
                Rearrange.currentIndexPath = indexPath
            }

        default:
            guard let snapshotView = Rearrange.snapshotView else {
                return
            }
            
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                snapshotView.transform = CGAffineTransform.identity
                snapshotView.center = cell.center
                snapshotView.alpha = 1.0
            }, completion: { (finished) in
                cell.alpha = 1.0
                Rearrange.snapshotView?.removeFromSuperview()
                Rearrange.snapshotView = nil
                Rearrange.currentIndexPath = nil
                Rearrange.snapshotOffset = nil
            })
            
            viewModel.saveReminders()
        }
    }
    
    private func snapshot(cell: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellImageView = UIImageView(image: image)
        cellImageView.layer.masksToBounds = false
        cellImageView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        cellImageView.layer.shadowRadius = 5.0
        cellImageView.layer.shadowOpacity = 0.3
        
        return cellImageView
    }
}
