//
//  TweetDetails.swift
//  TwitterDemo
//
//  Created by Ankit Teotia on 14/9/18.
//  Copyright © 2018 Ankit Teotia. All rights reserved.
//

import UIKit
import MapKit

class TweetDetails: NSObject, MKAnnotation {

    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
