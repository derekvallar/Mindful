//
//  ViewController.swift
//  Mindful
//
//  Created by Derek Vitaliano Vallar on 9/12/17.
//  Copyright © 2017 Derek Vallar. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    var cardGestureRecognizer: UIPanGestureRecognizer!
    var momentCardView: UIView!
    var originalCardLocation: CGPoint?

    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        setupLayout()
        cardGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardGestureRecognized))
        momentCardView?.addGestureRecognizer(cardGestureRecognizer)
    }

    func setupLayout() {
        view.backgroundColor = UIColor.lightGray
        navigationItem.title = Constants.appName

//        let memoryButton = UIButton(type: .system)
//        memoryButton.backgroundColor = UIColor.lightGray
//        memoryButton.setTitle("Memory", for: .normal)
//        memoryButton.addTarget(self, action: #selector(createMoment), for: .touchUpInside)
//        self.view.addSubview(memoryButton)
//
//        memoryButton.translatesAutoresizingMaskIntoConstraints = false
//        let margins = self.view.layoutMarginsGuide
//        memoryButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//        memoryButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//        memoryButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.33).isActive = true
//        memoryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        momentCardView = UIView()
        self.view.addSubview(momentCardView)

        momentCardView.backgroundColor = UIColor.white
        momentCardView.layer.cornerRadius = 10
        momentCardView.layer.shadowOffset = CGSize.zero
        momentCardView.layer.shadowRadius = 25
        momentCardView.layer.shadowOpacity = 0.25

        let viewMargins = self.view.layoutMarginsGuide
        NSLayoutConstraint.setupAndActivate(constraints: [
         momentCardView.widthAnchor.constraint(equalTo: viewMargins.widthAnchor, multiplier: 0.8),
         momentCardView.heightAnchor.constraint(equalTo: viewMargins.heightAnchor, multiplier: 0.7),
         momentCardView.centerXAnchor.constraint(equalTo: viewMargins.centerXAnchor),
         momentCardView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor)])

        originalCardLocation = momentCardView.center
        let cardMargins = momentCardView.layoutMarginsGuide

        let dateLabel = UILabel()
        momentCardView.addSubview(dateLabel)
        dateLabel.text = "11/02/94"
        dateLabel.textColor = UIColor.lightGray
        dateLabel.font = dateLabel.font.withSize(10.0)
        dateLabel.textAlignment = .center

        NSLayoutConstraint.setupAndActivate(constraints: [
         dateLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
         dateLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
         dateLabel.topAnchor.constraint(equalTo: cardMargins.topAnchor),
         dateLabel.heightAnchor.constraint(equalToConstant: 15.0)])

        let gpsLabel = UILabel()
        momentCardView.addSubview(gpsLabel)
        gpsLabel.text = "12231.123, -231.312239"
        gpsLabel.textColor = UIColor.lightGray
        gpsLabel.font = dateLabel.font.withSize(10.0)
        gpsLabel.textAlignment = .center

        NSLayoutConstraint.setupAndActivate(constraints: [
         gpsLabel.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
         gpsLabel.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
         gpsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
         gpsLabel.heightAnchor.constraint(equalToConstant: 15.0)])

        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        momentCardView.addSubview(imageView)

        NSLayoutConstraint.setupAndActivate(constraints: [
         imageView.leadingAnchor.constraint(equalTo: momentCardView.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: momentCardView.trailingAnchor),
         imageView.topAnchor.constraint(equalTo: gpsLabel.bottomAnchor, constant: Constants.spacingCGFloat),
         imageView.heightAnchor.constraint(equalTo: cardMargins.heightAnchor, multiplier: 0.33)])

        let titleField = UITextField()
        momentCardView.addSubview(titleField)
        titleField.borderStyle = .none
        titleField.placeholder = "Title"

        NSLayoutConstraint.setupAndActivate(constraints: [
         titleField.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
         titleField.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
         titleField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.spacingCGFloat)])

        let locationField = UITextField()
        momentCardView.addSubview(locationField)
        locationField.borderStyle = .none
        locationField.placeholder = "Location"

        NSLayoutConstraint.setupAndActivate(constraints: [
         locationField.leadingAnchor.constraint(equalTo: cardMargins.leadingAnchor),
         locationField.trailingAnchor.constraint(equalTo: cardMargins.trailingAnchor),
         locationField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: Constants.spacingCGFloat)])

    }

    @objc func createMoment() {

        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            editMoment(withDate: Date(), coordinate: nil)
        }
    }

    func editMoment(withDate date: Date, coordinate: CLLocationCoordinate2D?) {
        print("Location: \(coordinate.debugDescription), Date: \(date.debugDescription)")

    }

    @objc func cardGestureRecognized(gesture: UIPanGestureRecognizer) {

        if let cardView = gesture.view {
            let translation = gesture.translation(in: self.view)
            cardView.center = CGPoint(x: cardView.center.x + translation.x, y: cardView.center.y + translation.y)

            if gesture.state == .ended {
                if cardView.center.
            }

        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
}

extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            editMoment(withDate: location.timestamp, coordinate: location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

