//
//  GeoLocation.swift
//  Orchextra
//
//  Created by Judith Medina on 08/09/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoLocation {
    
    var lat: Double
    var lng: Double
    
    var country: String?
    var countryCode: String?
    var locality: String?
    var zip: String?
    var street: String?
    
    init(location: CLLocation, placemark: CLPlacemark?) {
        self.lat = Double(location.coordinate.latitude)
        self.lng = Double(location.coordinate.longitude)
        self.country = placemark?.country
        self.countryCode = placemark?.isoCountryCode
        self.locality = placemark?.locality
        self.zip = placemark?.postalCode
        self.street = placemark?.thoroughfare
    }
    
    func paramsGeoLocation() -> [String: Any] {
        let point = ["lat" : self.lat,
                     "lng" : self.lng]
        
        let params: [String: Any] = ["country" : self.country ?? "",
                      "countryCode" : self.countryCode ?? "",
                      "locality" : self.locality ?? "",
                      "zip" : self.zip ?? "",
                      "street" : self.street ?? "",
                      "point" : point]
        
        return ["geoLocation" : params]
    }
}
