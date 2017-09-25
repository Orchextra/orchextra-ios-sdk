//
//  RegionAnnotation.swift
//  Orchextra
//
//  Created by Carlos Vicente on 25/8/17.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import MapKit

class RegionAnnotation: NSObject, MKAnnotation {
    // MARK: - Attributes
    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - Initializers
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    func annotationView() -> MKAnnotationView {
        let annotationView = MKAnnotationView(
            annotation: self,
            reuseIdentifier: "RegionAnnotation"
        )
        annotationView.isEnabled = true
        annotationView.canShowCallout = true
        annotationView.image = #imageLiteral(resourceName: "geofence-blue")
        
        return annotationView
    }
}
