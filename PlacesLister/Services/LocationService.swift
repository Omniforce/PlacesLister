//
//  LocationService.swift
//  PlacesLister
//
//  Created by Brendan Ross on 6/30/17.
//  Copyright © 2017 Brendan Ross. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate {
    func locationUpdated(currentLocation: CLLocation)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var delegate: LocationServiceDelegate?
    var currentLocation: CLLocation? {
        didSet {
            stopUpdatingLocation()
            delegate?.locationUpdated(currentLocation: currentLocation!)
        }
    }
    
    override init () {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
        }
        
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.distanceFilter = 200
        self.locationManager?.delegate = self
    }
    
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
    }
    
}

