//
//  CreateMomentViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/15/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit

class CreateMomentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    func setupLayout() {
        let momentCardView = UIView()
        self.view.addSubview(momentCardView)

        momentCardView.layer.cornerRadius = 10
        momentCardView.layer.shadowOffset = CGSize.zero
        momentCardView.layer.shadowRadius = 5
        momentCardView.layer.shadowOpacity = 0.5

        let margins = self.view.layoutMarginsGuide
        momentCardView.translatesAutoresizingMaskIntoConstraints = false
        momentCardView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.7).isActive = true
        momentCardView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.6).isActive = true
        momentCardView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        momentCardView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
