//
//  PlaceCell.swift
//  PlacesLister v2
//
//  Created by Brendan Ross on 6/30/17.
//  Copyright © 2017 Brendan Ross. All rights reserved.
//

import UIKit

class PlaceCell : UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeLocation: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    var name: String? {
        didSet {
            placeName.text = name
        }
    }
    
    var location: String? {
        didSet {
            placeLocation.text = location
        }
    }
    
    var img: UIImage? {
        didSet {
            placeImage.image = img
        }
    }
    
}

