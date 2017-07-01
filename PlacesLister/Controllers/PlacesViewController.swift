//
//  PlacesViewController.swift
//  PlacesLister
//
//  Created by Brendan Ross on 6/30/17.
//  Copyright © 2017 Brendan Ross. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesViewController : UIViewController {
    
    var locationService: LocationService!
    var dataSource: PlacesDataSource!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchPlacesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = PlacesDataSource(places: [])
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
        
        self.locationService = LocationService()
        self.locationService.delegate = self
        self.locationService.startUpdatingLocation()
    }
    
    @IBAction func nearbyPlacesButtonPressed(sender: UIButton) {
        self.locationService.startUpdatingLocation()
    }
}

extension PlacesViewController: LocationServiceDelegate {
    func locationUpdated(currentLocation: CLLocation) {
        PlaceService.getNearbyLocations(location: currentLocation, completion: nearbyLocationCallback)
    }
    
    func nearbyLocationCallback(nearbyPlaces: [Place]) {
        DispatchQueue.main.async {
            self.dataSource.setPlaces(places: nearbyPlaces)
            self.tableView.reloadData()
        }
    }
}
