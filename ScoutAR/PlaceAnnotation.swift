//
//  PlaceAnnotation.swift
//  ScoutAR
//
//  Created by Ella on 4/26/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?

    init(location: CLLocationCoordinate2D, title: String) {
        self.coordinate = location
        self.title = title

        super.init()
    }
}
