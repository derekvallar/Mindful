//
//  ViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import MapKit

class CreateAMomentViewController: UIViewController {

    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        setupLayout()
    }

    func setupLayout() {
        view.backgroundColor = UIColor.white
        navigationItem.title = Constants.AppName

        let memoryButton = UIButton(type: .system)
        memoryButton.backgroundColor = UIColor.lightGray
        memoryButton.setTitle("Memory", for: .normal)
        memoryButton.addTarget(self, action: #selector(createMoment), for: .touchUpInside)
        self.view.addSubview(memoryButton)

        memoryButton.translatesAutoresizingMaskIntoConstraints = false
        let margins = self.view.layoutMarginsGuide
        memoryButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        memoryButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        memoryButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
        memoryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    @objc func createMoment() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            let date = Date()
            editMoment(withDate: date, coordinate: nil)
        }
    }

    func editMoment(withDate date: Date, coordinate: CLLocationCoordinate2D?) {

    }
}

extension CreateAMomentViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location: \(location.debugDescription)")
            editMoment(withDate: location.timestamp, coordinate: location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

