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

        switch longPress.state {
        case .began:
            guard let indexPath = tableView.indexPathForRow(at: location),
                let cell = tableView.cellForRow(at: indexPath) else {
                    return
            }

            if type(of: cell) == UIActionCell.self {
                return
            }

            if let selectedIndex = tableView.indexPathForSelectedRow {
                tableView(tableView, didDeselectRowAt: selectedIndex)
            }

            let view = snapshot(cell: cell)
            view.center = cell.center
            view.alpha = 0.0
            tableView.addSubview(view)

            UIView.animate(withDuration: 0.25, animations: {
                view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                view.alpha = 1.0
            }, completion: { finished in
                
                print("Finished:", finished)
                if finished {
                    cell.isHidden = true
                }
            })

            Rearrange.cell = cell
            Rearrange.snapshotView = view
            Rearrange.snapshotOffset = location.y - view.center.y
            Rearrange.currentIndexPath = indexPath

        case .changed:
            var indexPath: IndexPath!

            if let path = tableView.indexPathForRow(at: location) {
                indexPath = path
            } else {
                return
            }

            guard let snapshotView = Rearrange.snapshotView,
                  let currentIndexPath = Rearrange.currentIndexPath else {
                return
            }
            
            if snapshotView.alpha == 1.0 {
                snapshotView.alpha = 0.8
            }
            
            snapshotView.center.y = location.y - Rearrange.snapshotOffset!
            
            if currentIndexPath != indexPath {
                tableView.moveRow(at: currentIndexPath, to: indexPath)
                viewModel.swapReminders(fromIndexPath: currentIndexPath, to: indexPath)
                Rearrange.currentIndexPath = indexPath
            }

        default:
            guard let snapshotView = Rearrange.snapshotView,
                  let cell = Rearrange.cell else {
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                snapshotView.transform = CGAffineTransform.identity
                snapshotView.center = cell.center
                snapshotView.alpha = 1.0
            }, completion: { finished in
                cell.isHidden = false
                cell.alpha = 1.0
                Rearrange.clear()
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
