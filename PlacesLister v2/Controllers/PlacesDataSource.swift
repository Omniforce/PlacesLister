
//
//  PlacesDataSource.swift
//  PlacesLister v2
//
//  Created by Brendan Ross on 6/30/17.
//  Copyright © 2017 Brendan Ross. All rights reserved.
//

import UIKit

class PlacesDataSource: NSObject {
    var places: [Place]
    
    init(places: [Place]) {
        self.places = places
    }
    
    func setPlaces(places: [Place]) {
        self.places = places
    }
}

extension PlacesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlaceCell
        let place = places[indexPath.row]
        
        cell.name = place.name
        cell.location = place.location
        
        if let photoRef = place.photo {
            let imageHeight: Int = Int(cell.bounds.height)
            PlacesApiManager.getPlacePhoto(photoRef: photoRef, maxWidth: imageHeight, completion: { (image: UIImage) in
                DispatchQueue.main.async {
                    cell.img = image
                }
            })
        }
        
        return cell
    }
}
