//
//  PlacesApiManager.swift
//  PlacesLister v2
//
//  Created by Brendan Ross on 6/30/17.
//  Copyright © 2017 Brendan Ross. All rights reserved.
//

import CoreLocation
import UIKit

class PlacesApiManager {
    
    static func getNearbyLocations(location: CLLocation, completion: @escaping ([Place]) -> Void) {
        guard let nearbyPlacesUrl = createNearbyPlacesUrlWithQueries(location: location) else {
            return
        }
        
        let placesUrlRequest = URLRequest(url: nearbyPlacesUrl)
        let session = URLSession.shared
        
        let task = session.dataTask(with: placesUrlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print("Error when getting nearby places")
                return
            }
            
            var places: [Place] = []
            
            if let data = data,
                let json = try? JSON(data: data) {
                for result in json["results"].arrayValue {
                    let place = Place(id: result["id"].stringValue,
                                      name: result["name"].stringValue,
                                      location: result["vicinity"].stringValue,
                                      photo: result["photos"].array?[0]["photo_reference"].string)
                    places.append(place)
                }
            }
            
            completion(places)
        })
        task.resume()
    }
    
    static func getPlacePhoto(photoRef: String, maxWidth: Int, completion: @escaping (UIImage) -> Void) {
        guard let photoUrl = self.createPhotoUrlWithQueries(photoRef: photoRef, maxWidth: maxWidth) else {
            return
        }
        
        let photoRequest = URLRequest(url: photoUrl)
        let session = URLSession.shared
        
        let task = session.dataTask(with: photoRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print("Error when getting photo")
                return
            }
            
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            }
        })
        task.resume()
    }
    
    private static func createNearbyPlacesUrlWithQueries(location: CLLocation) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/place/nearbysearch/json"
        
        let apiKeyQuery = URLQueryItem(name: "key", value: "AIzaSyCaKHhCPNWwDn-qS2LcG4Iix0eywVZRSYU")
        let locationQuery = URLQueryItem(name: "location", value: String(location.coordinate.latitude) + "," + String(location.coordinate.longitude))
        let radiusQuery = URLQueryItem(name: "radius", value: "500")
        urlComponents.queryItems = [apiKeyQuery, locationQuery, radiusQuery]
        
        return urlComponents.url
    }
    
    static func createPhotoUrlWithQueries(photoRef: String, maxWidth: Int) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/place/photo"
        
        let apiKeyQuery = URLQueryItem(name: "key", value: "AIzaSyCaKHhCPNWwDn-qS2LcG4Iix0eywVZRSYU")
        let photoRefQuery = URLQueryItem(name: "photoreference", value: photoRef)
        let maxWidthQuery = URLQueryItem(name: "maxwidth", value: String(maxWidth))
        urlComponents.queryItems = [apiKeyQuery, photoRefQuery, maxWidthQuery]
        
        return urlComponents.url
    }
}
